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
                if (args.Length < 6)
                {
                    Console.WriteLine("Usage: ConsoleVault45 <vaultUrl> <secretName> <carId> <roleId> <secretId> [keyName]");
                    return 2;
                }

                string vaultUrl = args[0];
                string secretName = args[1];
                string carId = args[2];
                string roleId = args[3];
                string secretId = "";
                string keyName = "secret";          
                string envVarName = args[4];
                int version = int.Parse(args[5]);


                /* string vaultUrl = "https://hashicorp-vault-test.us.bank-dns.com";
                   string secretName = "dev/workaytpigl";
                   string carId = "2509";
                   string roleId = "9ce637ff-78b2-6159-cb95-595e2ec401c5";
                   int  version = 2;

                */

                // lets get secretID from an environment varable APP_2509_ENV


                try
                {
                  secretId = Environment.GetEnvironmentVariable(envVarName);
                }
                 catch (Exception ex) {
                                        Console.WriteLine($"Error retrieving environment variable {envVarName}: {ex.Message}");
                                        return 3;
                                     }

                // Ensure TLS 1.2 for HTTPS
                // Maybe add TLS 1.3 in future when .NET Framework supports it

                ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;

                string secretValue = FetchSecretValue(vaultUrl, secretName, carId, roleId, secretId, keyName, version);

                Console.WriteLine(secretValue);

                Console.ReadKey();

                return 0;
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine("Error: " + ex.Message);
                Console.Error.WriteLine(ex.StackTrace);
                return 1;
            }
        }


        private static string FetchSecretValue(string vaultUrl, string secretName, string carId, string roleId, string secretId, string keyName, int version)
        {
            string secretKeyName = string.IsNullOrEmpty(keyName) ? "TPIPassword" : keyName;

            var vaultAccess = new VaultAccessHelper(vaultUrl, secretName, carId, roleId, secretId,version);

            string token = vaultAccess.GetToken().GetAwaiter().GetResult();

            if (string.IsNullOrEmpty(token))
            {
                throw new Exception("Failed to acquire Vault token.");
            }

            return vaultAccess.GetSecret(secretName, secretKeyName).GetAwaiter().GetResult();
        }
    }
}