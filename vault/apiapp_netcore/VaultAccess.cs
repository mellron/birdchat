


using System;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace apiapp.Vault
{
    public class VaultAccess
    {
        private string vaultAddress = "";
        private string vaultToken = "";

        private string secretKey = "";
        private string secretName = "";
        private string carID = "";

        // create public getter and setters
        public string VaultAddress
        {
            get { return vaultAddress; }
            set { vaultAddress = value; }
        }
        public string VaultToken
        {
            get { return vaultToken; }
            set { vaultToken = value; }
        }

        public string SecretKey
        {
            get { return secretKey; }
            set { secretKey = value; }
        }

        public string SecretName
        {
            get { return secretName; }
            set { secretName = value; }
        }
        public string CarID
        {
            get { return carID; }
            set { carID = value; }
        }

        public VaultAccess()
        {

        }

        public VaultAccess(string vaultAddress, string vaultToken, string secretPath, string secretKey)
        {
            this.vaultAddress = vaultAddress;
            this.vaultToken = vaultToken;
            this.secretKey = secretKey;
        }

        /// <summary>
        ///  Gets the secret. 
        /// </summary>
        /// <returns></returns>
        public async Task<SecretResponse> GetSecret()   
        {
            return await GetSecret(SecretName);
        }

        /// <summary>
        ///  Gets the secret. takein a token
        /// </summary>
        /// <param name="SecretName"></param>
        /// <param name="token"></param>
        /// <returns></returns>
         public async Task<SecretResponse> GetSecret(string sSecretName,string token)         
         {
 
            vaultToken = token;
            return await GetSecret(sSecretName);
         }

        /// <summary>
        /// Gets the secret.
        /// </summary>
        /// <param name="SecretName"></param>
        /// <returns></returns>
        /// <exception cref="Exception"></exception>
        public async Task<SecretResponse> GetSecret(string sSecretName)
        {
            SecretName = sSecretName;
            using var client = new HttpClient();
            string secretPath = $"/v1/secret/data/{SecretName}";

            client.BaseAddress = new Uri(vaultAddress);
            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
            client.DefaultRequestHeaders.Add("X-Vault-Token", vaultToken);
            client.DefaultRequestHeaders.Add("X-Vault-Namespace", CarID);

            HttpResponseMessage response = await client.GetAsync(secretPath);

            if (response.IsSuccessStatusCode)
            {
                string data = await response.Content.ReadAsStringAsync();
                // Deserialize JSON response into SecretResponse object
 
                SecretResponse secretResponse = JsonConvert.DeserializeObject<SecretResponse>(data)!;

                return secretResponse;
            }
            else
            {
                throw new Exception("Failed to get secret");

            }
        }
        /// <summary>
        /// Gets the token from Hashicorp.
        /// </summary>
        ///
        /// <param name="roleID">The role id</param>
        /// <param name="secretID">The secret id</param>
        ///
        /// <returns>The token.</returns>
        public async Task<string> GetToken(string roleID, string secretID)
        {
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri(vaultAddress);
                client.DefaultRequestHeaders.Accept.Clear();
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                client.DefaultRequestHeaders.Add("X-Vault-Namespace", CarID);

                var data = new
                {
                    role_id = roleID,
                    secret_id = secretID
                };

                var content = new StringContent(JsonConvert.SerializeObject(data), System.Text.Encoding.UTF8, "application/json");

                HttpResponseMessage response = await client.PostAsync("v1/auth/approle/login", content);

                if (response.IsSuccessStatusCode)
                {
                    var result = await response.Content.ReadAsStringAsync();
                    dynamic token = JsonConvert.DeserializeObject(result)!;
                    vaultToken = token.auth.client_token;
                    return vaultToken;
                }
                else
                {
                    throw new Exception("Failed to get token");

                }
            }
        }



    }

}

