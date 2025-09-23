using System;
using System.Net;
using apiapp.Vault;

namespace ConsoleVault45
{
    internal class Program
    {
        private static int Main(string[] args)
        {
            try
            {
                if (args.Length < 5)
                {
                    Console.WriteLine("Usage: ConsoleVault45 <vaultUrl> <secretName> <carId> <roleId> <secretId> [keyName]");
                    return 2;
                }

                string vaultUrl = args[0];
                string secretName = args[1];
                string carId = args[2];
                string roleId = args[3];
                string secretId = args[4];
                string keyName = args.Length >= 6 ? args[5] : null;

                // Ensure TLS 1.2 for HTTPS
                ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;

                string secretValue = FetchSecretValue(vaultUrl, secretName, carId, roleId, secretId, keyName);

                Console.WriteLine(secretValue);

                return 0;
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine("Error: " + ex.Message);
                Console.Error.WriteLine(ex.StackTrace);
                return 1;
            }
        }


        private static string FetchSecretValue(string vaultUrl, string secretName, string carId, string roleId, string secretId, string keyName)
        {
            string secretKeyName = string.IsNullOrEmpty(keyName) ? "TPIPassword" : keyName;

            var vaultAccess = new HROPVaultAccess(vaultUrl, secretName, carId, roleId, secretId);

            string token = vaultAccess.GetToken().GetAwaiter().GetResult();

            if (string.IsNullOrEmpty(token))
            {
                throw new Exception("Failed to acquire Vault token.");
            }

            var secretResponse = vaultAccess.GetSecret(secretName).GetAwaiter().GetResult();

            if (secretResponse == null || secretResponse.Data == null || secretResponse.Data.Secrets == null)
            {
                throw new Exception("Vault response did not contain any secret data.");
            }

            string secretValue;

            if (!secretResponse.Data.Secrets.TryGetValue(secretKeyName, out secretValue))
            {
                throw new Exception("Secret key '" + secretKeyName + "' not found in Vault response.");
            }

            return secretValue;
        }
    }
}
