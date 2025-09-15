Vault Access from SSIS (SQL Server Integration Services)

Overview
- Use the .NET Framework 4.5–compatible classes in `apiapp_net45` to fetch a Vault token (AppRole) and read secrets from KV v2 without Newtonsoft.Json.
- Target environment: SSIS Script Task (C#) running on .NET Framework 4.5+.

Prerequisites
- Network access from SSIS host to your Vault endpoint.
- Environment variables on the SSIS runtime account:
  - `ROLE_ID`
  - `SECRET_ID`
- SSIS variables configured (example names used below):
  - `VaultUrl` (e.g., https://vault.mycorp.com)
  - `HropAPISecretName` (e.g., secret/app/service/creds)
  - `CarID` (Vault namespace if required; otherwise empty)
- TLS 1.2 enabled for outbound HTTPS.
- Script Task references: `System`, `System.Net.Http`, `System.Runtime.Serialization`.

Option A: Reference a compiled Class Library (recommended)
1) Create a Class Library project targeting .NET Framework 4.5.
2) Add these files from this repo to the project:
   - `apiapp_net45/SecretsData.cs`
   - `apiapp_net45/VaultAccess.cs`
   - `apiapp_net45/HROPVaultAccess.cs`
3) Build the project, producing e.g., `Company.Vault.dll`.
4) On the SSIS machine, in your Script Task:
   - Click Edit Script → Project → Add Reference → Browse, select the built DLL.
   - Ensure framework references include `System.Net.Http` and `System.Runtime.Serialization`.

Option B: Paste classes into the Script Task
- Edit Script → Show All Files → Right‑click project → Add → Class…
- Paste the contents of the three `apiapp_net45` files into the Script project.

Script Task example (C#)
- Reads SSIS variables and environment variables, calls Vault, and stores a secret value back into an SSIS variable.

```csharp
using System;
using System.Net;
using System.Threading.Tasks;
using Microsoft.SqlServer.Dts.Runtime;
using apiapp.Vault; // Namespace from the apiapp_net45 classes

[Microsoft.SqlServer.Dts.Tasks.ScriptTask.SSISScriptTaskEntryPoint]
public partial class ScriptMain : Microsoft.SqlServer.Dts.Tasks.ScriptTask.VSTARTScriptObjectModelBase
{
    public void Main()
    {
        try
        {
            // Force TLS 1.2 on older hosts
            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;

            // Read SSIS variables
            string vaultUrl = (string)Dts.Variables["User::VaultUrl"].Value;
            string secretName = (string)Dts.Variables["User::HropAPISecretName"].Value;
            string carId = (string)Dts.Variables["User::CarID"].Value; // can be empty if not using namespaces

            // Read environment variables
            string roleId = Environment.GetEnvironmentVariable("ROLE_ID");
            string secretId = Environment.GetEnvironmentVariable("SECRET_ID");

            // Run async code synchronously in Script Task
            Task.Run(async () =>
            {
                var vault = new HROPVaultAccess(vaultUrl, secretName, carId, roleId, secretId);

                string token = await vault.GetToken();
                var secret = await vault.GetSecret(secretName);

                // Example: pull a specific key from the secret data
                string keyName = "my_api_key"; // change to your actual key
                string keyValue;
                if (!secret.Data.Secrets.TryGetValue(keyName, out keyValue))
                {
                    throw new Exception("Key not found in Vault secret: " + keyName);
                }

                // Write back to an SSIS variable
                Dts.Variables["User::MyApiKey"].Value = keyValue;
            }).GetAwaiter().GetResult();

            Dts.TaskResult = (int)ScriptResults.Success;
        }
        catch (Exception ex)
        {
            Dts.Events.FireError(0, "Vault", ex.Message + "\n" + ex.StackTrace, string.Empty, 0);
            Dts.TaskResult = (int)ScriptResults.Failure;
        }
    }
}
```

Notes and tips
- KV v2 paths: if your secret path includes `/data/`, keep using `secret/data/<path>`; the provided `VaultAccess` already targets KV v2.
- Namespaces: if Vault namespaces are not used, pass an empty string for `carID` in the `HROPVaultAccess` constructor.
- Multiple keys: `secret.Data.Secrets` is a `Dictionary<string,string>` containing all keys at that path.
- No Newtonsoft.Json: The implementation uses `DataContractJsonSerializer` to avoid extra dependencies.
- Timeouts and retries: For long‑running networks, you can wrap calls in retry logic or adjust `HttpClient.Timeout` by editing `VaultAccess` to create a custom `HttpClient`.
- TLS errors: Ensure the host supports TLS 1.2 and outbound HTTPS. The snippet sets TLS 1.2 explicitly.
- System.Net.Http binding issues: On older SSIS hosts, if you see assembly version conflicts for `System.Net.Http`, install the matching .NET Framework updates or add binding redirects at the machine config level. If needed, contact your admin.

Constructor summary
- `new HROPVaultAccess(vaultAddress, secretName, carID, roleID, secretID)`
  - `vaultAddress`: e.g., `https://vault.mycorp.com`
  - `secretName`: Vault KV v2 path (e.g., `secret/app/service/creds`)
  - `carID`: Vault namespace (if not used, pass `""`)
  - `roleID`: AppRole role ID (from environment or SSIS variable)
  - `secretID`: AppRole secret ID (from environment or SSIS variable)

Minimal sanity test (outside SSIS)
- Create a small .NET 4.5 console app referencing the same library, call the same code, and verify you receive a token and can read a known secret before wiring into SSIS.

Console example (included)
- Location: `examples/ConsoleVault45`
- Build: open `ConsoleVault45.csproj` in Visual Studio and build.
- Run:
  - `ConsoleVault45 <vaultUrl> <secretName> <carId> <roleId> <secretId> [keyName]`
  - Example: `ConsoleVault45 https://vault.mycorp.com secret/app/service/creds "" %ROLE_ID% %SECRET_ID% my_api_key`
  - Pass empty string for `carId` if namespaces are not used.
