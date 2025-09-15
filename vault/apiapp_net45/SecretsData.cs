using System;
using System.Collections.Generic;
using System.Runtime.Serialization;

namespace apiapp.Vault
{
    [DataContract]
    public class SecretsData
    {
        [DataMember(Name = "data")]
        public Dictionary<string, string> Secrets { get; set; }

        [DataMember(Name = "metadata")]
        public Metadata Metadata { get; set; }
    }

    [DataContract]
    public class Metadata
    {
        // Use string for broad compatibility with JSON date formats on .NET 4.5
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

    // Used for auth/login response when exchanging role_id + secret_id for a client_token
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

