

using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;
using Newtonsoft.Json;

namespace apiapp.Vault;
// Root myDeserializedClass = JsonConvert.DeserializeObject<Root>(myJsonResponse);
      public class SecretsData
    {
        [JsonProperty("data")]
        [JsonPropertyName("data")]
        public required Dictionary<string, string> Secrets { get; set; }

        [JsonProperty("metadata")]
        [JsonPropertyName("metadata")]
        public required Metadata Metadata { get; set; }

    }

    public class Metadata
    {
        [JsonProperty("created_time")]
        [JsonPropertyName("created_time")]
        public DateTime CreatedTime { get; set; }

        [JsonProperty("custom_metadata")]
        [JsonPropertyName("custom_metadata")]
        public required object CustomMetadata { get; set; }

        [JsonProperty("deletion_time")]
        [JsonPropertyName("deletion_time")]
        public required string DeletionTime { get; set; }

        [JsonProperty("destroyed")]
        [JsonPropertyName("destroyed")]
        public bool Destroyed { get; set; }

        [JsonProperty("version")]
        [JsonPropertyName("version")]
        public int Version { get; set; }
    }

    public class SecretResponse
    {
        [JsonProperty("request_id")]
        [JsonPropertyName("request_id")]
        public required string RequestId { get; set; }

        [JsonProperty("lease_id")]
        [JsonPropertyName("lease_id")]
        public required string LeaseId { get; set; }

        [JsonProperty("renewable")]
        [JsonPropertyName("renewable")]
        public bool Renewable { get; set; }

        [JsonProperty("lease_duration")]
        [JsonPropertyName("lease_duration")]
        public int LeaseDuration { get; set; }

        [JsonProperty("data")]
        [JsonPropertyName("data")]
        public required SecretsData Data { get; set; }

        [JsonProperty("wrap_info")]
        [JsonPropertyName("wrap_info")]
        public required object WrapInfo { get; set; }

        [JsonProperty("warnings")]
        [JsonPropertyName("warnings")]
        public required object Warnings { get; set; }

        [JsonProperty("auth")]
        [JsonPropertyName("auth")]
        public required object Auth { get; set; }

        [JsonProperty("mount_type")]
        [JsonPropertyName("mount_type")]
        public required string MountType { get; set; }
    }

