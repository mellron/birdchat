using System;
using System.IO;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Json;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace apiapp.Vault
{
    public class VaultAccess
    {
        private string vaultAddress = "";
        private string vaultToken = "";

        private string secretKey = "";
        private string secretName = "";
        private string carID = "";

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

        public async Task<SecretResponse> GetSecret()
        {
            return await GetSecret(SecretName);
        }

        public async Task<SecretResponse> GetSecret(string sSecretName, string token)
        {
            vaultToken = token;
            return await GetSecret(sSecretName);
        }

        public async Task<SecretResponse> GetSecret(string sSecretName)
        {
            SecretName = sSecretName;
            using (var client = new HttpClient())
            {
                string secretPath = string.Format("/v1/secret/data/{0}", SecretName);

                client.BaseAddress = new Uri(vaultAddress);
                client.DefaultRequestHeaders.Accept.Clear();
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                if (!string.IsNullOrEmpty(vaultToken))
                {
                    client.DefaultRequestHeaders.Add("X-Vault-Token", vaultToken);
                }
                if (!string.IsNullOrEmpty(CarID))
                {
                    client.DefaultRequestHeaders.Add("X-Vault-Namespace", CarID);
                }

                HttpResponseMessage response = await client.GetAsync(secretPath).ConfigureAwait(false);
                if (response.IsSuccessStatusCode)
                {
                    string data = await response.Content.ReadAsStringAsync().ConfigureAwait(false);
                    DataContractJsonSerializer serializer = new DataContractJsonSerializer(typeof(SecretResponse));
                    using (var ms = new MemoryStream(Encoding.UTF8.GetBytes(data)))
                    {
                        var secretResponse = (SecretResponse)serializer.ReadObject(ms);
                        return secretResponse;
                    }
                }
                else
                {
                    throw new Exception("Failed to get secret");
                }
            }
        }

        public async Task<string> GetToken(string roleID, string secretID)
        {
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri(vaultAddress);
                client.DefaultRequestHeaders.Accept.Clear();
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                if (!string.IsNullOrEmpty(CarID))
                {
                    client.DefaultRequestHeaders.Add("X-Vault-Namespace", CarID);
                }

                // Prepare JSON manually to avoid external JSON libs
                string json = string.Concat("{\"role_id\":\"", EscapeJson(roleID), "\",\"secret_id\":\"", EscapeJson(secretID), "\"}");
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                HttpResponseMessage response = await client.PostAsync("v1/auth/approle/login", content).ConfigureAwait(false);
                if (response.IsSuccessStatusCode)
                {
                    var result = await response.Content.ReadAsStringAsync().ConfigureAwait(false);
                    var serializer = new DataContractJsonSerializer(typeof(LoginResponse));
                    using (var ms = new MemoryStream(Encoding.UTF8.GetBytes(result)))
                    {
                        var login = (LoginResponse)serializer.ReadObject(ms);
                        if (login != null && login.Auth != null && !string.IsNullOrEmpty(login.Auth.ClientToken))
                        {
                            vaultToken = login.Auth.ClientToken;
                            return vaultToken;
                        }
                    }
                    throw new Exception("Login response missing client_token");
                }
                else
                {
                    throw new Exception("Failed to get token");
                }
            }
        }

        private static string EscapeJson(string s)
        {
            if (string.IsNullOrEmpty(s)) return string.Empty;
            return s.Replace("\\", "\\\\").Replace("\"", "\\\"");
        }
    }
}
