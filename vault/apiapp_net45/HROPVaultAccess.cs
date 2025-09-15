using System;
using System.Threading.Tasks;

namespace apiapp.Vault
{
    public class HROPVaultAccess : VaultAccess
    {
        public string RoleID { get; set; }
        public string SecretID { get; set; }

        public HROPVaultAccess(string vaultAddress, string secretName, string carID, string roleID, string secretID)
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
            return await base.GetToken(RoleID, SecretID);
        }

        public new async Task<SecretResponse> GetSecret(string SecretName)
        {
            return await base.GetSecret(SecretName);
        }

        public new async Task<SecretResponse> GetSecret(string SecretName, string token)
        {
            return await base.GetSecret(SecretName, token);
        }
    }
}
