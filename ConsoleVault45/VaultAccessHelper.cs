using System;
using System.Threading.Tasks;

namespace apiapp.Vault
{
    public class VaultAccessHelper : VaultAccess
    {
        public string RoleID { get; set; }
        public string SecretID { get; set; }
        public string Token { get; set; }


        public VaultAccessHelper(string vaultAddress, string secretName, string carID, string roleID, string secretID, int Version = 1)
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
            this.Version = Version;

        }

        public async Task<string> GetToken()
        {
            this.Token = await base.GetToken(RoleID, SecretID).ConfigureAwait(false);
            return this.Token;
        }

        public async Task<string> GetSecret(string secretName, string secretKeyName)
        {
            // check if Token is null or not
            if (string.IsNullOrEmpty(this.Token))
            {
                throw new Exception("Vault token is null or empty. Please acquire a token first.");
            }

            var secretResponse = await base.GetSecret(secretName, this.Token).ConfigureAwait(false);

            return ExtractSecretValue(secretResponse, secretKeyName);
        }

        public async Task<string> GetSecret(string secretName, string secretKeyName, string token)
        {
            var secretResponse = await base.GetSecret(secretName, token).ConfigureAwait(false);

            return ExtractSecretValue(secretResponse, secretKeyName);
        }

        private static string ExtractSecretValue(SecretResponse secretResponse, string secretKeyName)
        {
            if (secretResponse == null || secretResponse.Data == null || secretResponse.Data.SecretValues == null)
            {
                throw new Exception("Vault response did not contain any secret data.");
            }

            var secrets = secretResponse.Data.SecretValues;

            var prop = typeof(SecretValues).GetProperty(secretKeyName, System.Reflection.BindingFlags.IgnoreCase | System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.Instance);

            if (prop == null)
            {
                throw new Exception("Secret key '" + secretKeyName + "' not found in Vault response.");
            }

            var secretValue = prop.GetValue(secrets) as string;

            if (string.IsNullOrEmpty(secretValue))
            {
                throw new Exception("Secret key '" + secretKeyName + "' was found but has no value.");
            }

            return secretValue;
        }
    }
}