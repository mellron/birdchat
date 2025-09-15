


using System;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace apiapp.Vault
{
    public class HROPVaultAccess : VaultAccess
    {
        public string RoleID { get; set; }
        public string SecretID { get; set; }
        /**
            * Initializes a new instance of the <see cref="HROPVaultAccess"/> class.
        */
        public HROPVaultAccess() : base()
        {
        
            base.VaultAddress = Util.ConfigurationProvider.Configuration?["HashiCorpVault:VaultUrl"]?.ToString() ?? throw new ArgumentNullException("HashilCorpVault:VaultUrl", "VaultUrl is not set.");
            base.SecretName = Util.ConfigurationProvider.Configuration?["HashiCorpVault:HropAPISecretName"]?.ToString() ?? throw new ArgumentNullException("HashilCorpVault:SecretName", "SecretName is not set.");
            base.CarID = Util.ConfigurationProvider.Configuration?["HashiCorpVault:CarID"]?.ToString() ?? throw new ArgumentNullException("HashilCorpVault:CarID", "CarID is not set.");
 
            // Pull RoleID from Environment variable "ROLE_ID"
            RoleID = Environment.GetEnvironmentVariable("ROLE_ID") ?? throw new ArgumentNullException("ROLE_ID", "Environment variable ROLE_ID is not set.");
                
            // Pull SecretID from Environment variable "SECRET_ID"
            SecretID = Environment.GetEnvironmentVariable("SECRET_ID") ?? throw new ArgumentNullException("SECRET_ID", "Environment variable SECRET_ID is not set.");

        }

        /**
            * Gets the token.
            *
            * @returns The token.
        */
        public async Task<string> GetToken()
        {
            // call the parent GetToken
            return await base.GetToken(RoleID, SecretID);
         
        }
        /**
            * Gets the secret.
            *
            * @returns The secret.
        */
        public new async Task<SecretResponse> GetSecret(string SecretName)
        {
            // call the parent GetSecret
            return await base.GetSecret(SecretName);
        }

        public new async Task<SecretResponse> GetSecret(string SecretName,string token)
        {
            // call the parent GetSecret
            return await base.GetSecret(SecretName,token);
        }
    }
}


