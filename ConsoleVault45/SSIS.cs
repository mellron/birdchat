using System;
using System.Net;
using Microsoft.SqlServer.Dts.Tasks.ScriptTask;  // added by template
using Microsoft.SqlServer.Dts.Runtime;
using apiapp.Vault;  // your helper namespace

[Microsoft.SqlServer.Dts.Tasks.ScriptTask.SSISScriptTaskEntryPointAttribute]
public partial class ScriptMain : Microsoft.SqlServer.Dts.Tasks.ScriptTask.VSTARTScriptObjectModelBase
{
    public void Main()
    {
        try
        {
            // 1) Read required variables (all under the User:: namespace)
            string vaultUrl   = GetRequiredString("User::HashiCorpVaultURL");
            string secretName = GetRequiredString("User::HashiSecretName");
            string carId      = GetRequiredString("User::CarID");
            string roleId     = GetRequiredString("User::HashiCorpRoleID");
            string envVarName = GetRequiredString("User::HashiCorpEnvVarable"); // note: variable name as provided

            // 2) Optional variables with defaults
            string keyName = GetOptionalString("User::HashiCorpKeyName", "secret");
            int version    = GetOptionalInt("User::HashiCorpVersion", 1);

            // 3) SecretId comes from the machine/process environment
            string secretId = FetchSecretIdFromEnvironment(envVarName);

            // 4) Force TLS 1.2 for outbound calls
            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;

            // 5) Call your Vault helper
            string secretKeyName = string.IsNullOrEmpty(keyName) ? "TPIPassword" : keyName;

            var vaultAccess = new VaultAccessHelper(
                vaultUrl: vaultUrl,
                secretName: secretName,
                carId: carId,
                roleId: roleId,
                secretId: secretId,
                version: version
            );

            string token = vaultAccess.GetToken().GetAwaiter().GetResult();

            if (string.IsNullOrEmpty(token))
                throw new InvalidOperationException("Failed to acquire Vault token.");

            string secretValue = vaultAccess.GetSecret(secretName, secretKeyName).GetAwaiter().GetResult();

            // 6) Optionally write the fetched secret back to a user variable if present
            TrySetVariable("User::HashiSecretValue", secretValue);

            // 7) Success
            Dts.Events.FireInformation(0, "Vault", "Secret successfully retrieved.", string.Empty, 0, ref _fireAgain);
            Dts.TaskResult = (int)ScriptResults.Success;
        }
        catch (Exception ex)
        {
            Dts.Events.FireError(0, "Vault", ex.Message, string.Empty, 0);
            Dts.TaskResult = (int)ScriptResults.Failure;
        }
    }

    // -------- helpers --------
    private bool _fireAgain = false;

    private string GetRequiredString(string qualifiedName)
    {
        if (!HasVariable(qualifiedName))
            throw new ArgumentException($"Required SSIS variable '{qualifiedName}' was not found.");

        object v = Dts.Variables[qualifiedName].Value;
        string s = v?.ToString();
        if (string.IsNullOrWhiteSpace(s))
            throw new ArgumentException($"SSIS variable '{qualifiedName}' must contain a non-empty string value.");

        return s;
    }

    private string GetOptionalString(string qualifiedName, string defaultValue)
    {
        if (!HasVariable(qualifiedName))
            return defaultValue;

        object v = Dts.Variables[qualifiedName].Value;
        string s = v?.ToString();
        return string.IsNullOrWhiteSpace(s) ? defaultValue : s;
    }

    private int GetOptionalInt(string qualifiedName, int defaultValue)
    {
        if (!HasVariable(qualifiedName))
            return defaultValue;

        object v = Dts.Variables[qualifiedName].Value;
        if (v == null) return defaultValue;

        if (v is int n) return n;

        if (int.TryParse(v.ToString(), out int parsed))
            return parsed;

        throw new ArgumentException($"SSIS variable '{qualifiedName}' could not be parsed as an integer.");
    }

    private bool HasVariable(string qualifiedName)
    {
        try
        {
            // Variables collection throws if key missing, so check via Contains
            foreach (Variable var in Dts.Variables)
            {
                if (string.Equals(var.QualifiedName, qualifiedName, StringComparison.OrdinalIgnoreCase) ||
                    string.Equals(var.Name, qualifiedName, StringComparison.OrdinalIgnoreCase))
                {
                    return true;
                }
            }
            // Also allow direct indexer success as a fast path
            return Dts.Variables.Contains(qualifiedName);
        }
        catch
        {
            return false;
        }
    }

    private void TrySetVariable(string qualifiedName, object value)
    {
        if (!HasVariable(qualifiedName)) return;

        try
        {
            // Requires the variable to be listed in ReadWriteVariables
            Dts.Variables[qualifiedName].Value = value;
        }
        catch (Exception ex)
        {
            Dts.Events.FireWarning(0, "Vault", $"Could not set {qualifiedName}: {ex.Message}", string.Empty, 0);
        }
    }

    private string FetchSecretIdFromEnvironment(string envVarName)
    {
        try
        {
            string secretId = Environment.GetEnvironmentVariable(envVarName);
            if (string.IsNullOrWhiteSpace(secretId))
                throw new InvalidOperationException($"Environment variable '{envVarName}' is not defined or empty.");
            return secretId;
        }
        catch (Exception ex) when (ex is not InvalidOperationException)
        {
            throw new InvalidOperationException($"Error retrieving environment variable '{envVarName}'.", ex);
        }
    }

    enum ScriptResults
    {
        Success = Microsoft.SqlServer.Dts.Runtime.DTSExecResult.Success,
        Failure = Microsoft.SqlServer.Dts.Runtime.DTSExecResult.Failure
    }
}
