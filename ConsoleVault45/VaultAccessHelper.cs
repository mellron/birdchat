using System;
using System.Threading.Tasks;

namespace apiapp.Vault
{
    public class VaultAccessHelper : VaultAccess
    {
        public string RoleID { get; set; }
        public string SecretID { get; set; }

        public VaultAccessHelper(string vaultAddress, string secretName, string carID, string roleID, string secretID)
            : base()
        {
            if (string.IsNullOrEmpty(vaultAddress)) throw new ArgumentNullException("vaultAddress");
            if (string.IsNullOrEmpty(secretName)) throw new ArgumentNullException("secretName");
            if (string.IsNullOrEmpty(carID)) throw new ArgumentNullException("carID");
            if (string.IsNullOrEmpty(roleID)) throw new ArgumentNullException("roleID");
            if (string.IsNullOrEmpty(secretID)) throw new ArgumentNullException("secretID");

            base.VaultAddress = vaultAddress;
            base.SecretName = secretName;
            base.CarID = carID;
            this.RoleID = roleID;
            this.SecretID = secretID;
        }

        public async Task<string> GetToken()
        {
            return await base.GetToken(RoleID, SecretID).ConfigureAwait(false);
        }

        public async Task<string> GetSecret(string secretName, string secretKeyName)
        {
            var secretResponse = await base.GetSecret(secretName).ConfigureAwait(false);

            return ExtractSecretValue(secretResponse, secretKeyName);
        }

        public async Task<string> GetSecret(string secretName, string secretKeyName, string token)
        {
            var secretResponse = await base.GetSecret(secretName, token).ConfigureAwait(false);

            return ExtractSecretValue(secretResponse, secretKeyName);
        }

        private static string ExtractSecretValue(SecretResponse secretResponse, string secretKeyName)
        {
            if (secretResponse == null || secretResponse.Data == null || secretResponse.Data.Secrets == null)
            {
                throw new Exception("Vault response did not contain any secret data.");
            }

            if (!secretResponse.Data.Secrets.TryGetValue(secretKeyName, out var secretValue))
            {
                throw new Exception("Secret key '" + secretKeyName + "' not found in Vault response.");
            }

            return secretValue;
        }
    }
}
