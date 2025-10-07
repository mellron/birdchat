using System;
using System.Runtime.Serialization;

namespace apiapp.Vault
{
    [DataContract]
    public class SecretsData
    {
        // This maps to the inner "data" object in the Vault response
        [DataMember(Name = "data")]
        public SecretValues SecretValues { get; set; }

        [DataMember(Name = "metadata")]
        public Metadata Metadata { get; set; }
    }

    [DataContract]
    public class SecretValues
    {
        [DataMember(Name = "certpassphrase")]
        public string CertPassphrase { get; set; }

        [DataMember(Name = "key")]
        public string Key { get; set; }

        [DataMember(Name = "secret")]
        public string Secret { get; set; }
    }

    [DataContract]
    public class Metadata
    {
        [DataMember(Name = "created_time")]
        public string CreatedTime { get; set; }

        [DataMember(Name = "custom_metadata")]
        public object CustomMetadata { get; set; }

        [DataMember(Name = "deletion_time")]
        public string DeletionTime { get; set; }

        [DataMember(Name = "destroyed")]
        public bool Destroyed { get; set; }

        [DataMember(Name = "version")]
        public int Version { get; set; }
    }

    [DataContract]
    public class SecretResponse
    {
        [DataMember(Name = "request_id")]
        public string RequestId { get; set; }

        [DataMember(Name = "lease_id")]
        public string LeaseId { get; set; }

        [DataMember(Name = "renewable")]
        public bool Renewable { get; set; }

        [DataMember(Name = "lease_duration")]
        public int LeaseDuration { get; set; }

        [DataMember(Name = "data")]
        public SecretsData Data { get; set; }

        [DataMember(Name = "wrap_info")]
        public object WrapInfo { get; set; }

        [DataMember(Name = "warnings")]
        public object Warnings { get; set; }

        [DataMember(Name = "auth")]
        public object Auth { get; set; }

        [DataMember(Name = "mount_type")]
        public string MountType { get; set; }
    }

    [DataContract]
    internal class LoginResponse
    {
        [DataMember(Name = "auth")]
        public LoginAuth Auth { get; set; }
    }

    [DataContract]
    internal class LoginAuth
    {
        [DataMember(Name = "client_token")]
        public string ClientToken { get; set; }
    }
}