using System;
using System.IO;
using System.Linq;
using System.Text;   

namespace Util 
{
    /// <summary>
    /// Provides methods to convert a ZIP file into Base64-encoded text chunks.
    /// </summary>
    public static class ZipToText
    {
        /// <summary>
        /// Reads the input ZIP file, encodes it as Base64, and splits the result into .txt chunks.
        /// </summary>
        /// <param name="inputZipPath">Path to the ZIP file to convert.</param>
        /// <param name="outputFolder">Directory where chunk files will be written.</param>
        /// <param name="chunkSizeMB">Maximum size of each chunk in megabytes.</param>
        public static void Convert(string inputZipPath, string outputFolder, int chunkSizeMB = 1)
        {
            if (!File.Exists(inputZipPath))
                throw new FileNotFoundException("Input ZIP file not found.", inputZipPath);

            if (!Directory.Exists(outputFolder))
                Directory.CreateDirectory(outputFolder);

            // Read entire ZIP into memory
            byte[] zipBytes = File.ReadAllBytes(inputZipPath);
            string base64 = System.Convert.ToBase64String(zipBytes);

            // Determine chunk sizes
            int chunkSize = chunkSizeMB * 1024 * 1024;
            int totalChunks = (int)Math.Ceiling((double)base64.Length / chunkSize);

            for (int i = 0; i < totalChunks; i++)
            {
                int offset = i * chunkSize;
                int currentSize = Math.Min(chunkSize, base64.Length - offset);
                string chunkData = base64.Substring(offset, currentSize);

                string chunkFileName = Path.Combine(outputFolder, $"chunk_{i:D4}.txt");
                File.WriteAllText(chunkFileName, chunkData);
            }
        }
    }
}
