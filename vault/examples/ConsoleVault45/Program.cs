using System;
using System.Net;
using System.Threading.Tasks;
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

                RunAsync(vaultUrl, secretName, carId, roleId, secretId, keyName).GetAwaiter().GetResult();
                return 0;
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine("Error: " + ex.Message);
                Console.Error.WriteLine(ex.StackTrace);
                return 1;
            }
        }

        private static async Task RunAsync(string vaultUrl, string secretName, string carId, string roleId, string secretId, string keyName)
        {
            var hrop = new HROPVaultAccess(vaultUrl, secretName, carId, roleId, secretId);

            string token = await hrop.GetToken();
            Console.WriteLine("Token acquired: " + (string.IsNullOrEmpty(token) ? "<empty>" : "<redacted>"));

            var secret = await hrop.GetSecret(secretName);
            Console.WriteLine("Secret path: " + secretName);
            Console.WriteLine("Keys:");
            foreach (var kvp in secret.Data.Secrets)
            {
                if (!string.IsNullOrEmpty(keyName) && !string.Equals(kvp.Key, keyName, StringComparison.Ordinal))
                {
                    continue;
                }
                Console.WriteLine(" - " + kvp.Key + " = " + kvp.Value);
            }
        }
    }
}

