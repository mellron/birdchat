using System;
using System.IO;
using System.Linq;
using System.Text;

namespace Util
{
    public static class TextToZip
    {
        /// <summary>
        /// Reads .txt chunk files from the input folder, combines and decodes them,
        /// and writes out the reconstructed ZIP file.
        /// </summary>
        /// <param name="inputFolder">Directory containing chunk_*.txt files.</param>
        /// <param name="outputZipPath">Path for the output ZIP file.</param>
        public static void Reconstruct(string inputFolder, string outputZipPath)
        {
            if (!Directory.Exists(inputFolder))
                throw new DirectoryNotFoundException($"Input folder not found: {inputFolder}");

            // Find and sort chunk files
            var chunkFiles = Directory
                .GetFiles(inputFolder, "chunk_*.txt")
                .OrderBy(f => f)
                .ToArray();

            if (chunkFiles.Length == 0)
                throw new FileNotFoundException("No chunk files found in the input folder.");

            // Combine all Base64 text
            var sb = new StringBuilder();
            foreach (var file in chunkFiles)
            {
                sb.Append(File.ReadAllText(file));
            }

            // Decode Base64 to binary
            byte[] zipBytes;
            try
            {
                zipBytes = Convert.FromBase64String(sb.ToString());
            }
            catch (FormatException ex)
            {
                throw new InvalidDataException("Failed to decode Base64 content.", ex);
            }

            // Write out the ZIP file
            File.WriteAllBytes(outputZipPath, zipBytes);
        }
    }
}