using System;
using System.IO;
using Util;

class Program
{

    static void Main(string[] args)
    {
        if (args.Length < 2)
        {
            Console.WriteLine("Usage: TextToZip <input-folder> <output.zip>");
            return;
        }

        string inputFolder = args[0];
        string outputZipPath = args[1];

        try
        {
            Console.WriteLine("Reconstructing ZIP from text chunks...");
            TextToZip.Reconstruct(inputFolder, outputZipPath);
            Console.WriteLine("Reconstruction complete.");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error: {ex.Message}");
        }
    }

}
