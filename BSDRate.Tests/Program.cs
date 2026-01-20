using System;

namespace BSDRate.Tests
{
    /// <summary>
    /// TPP-9855 Validation Tests
    /// Tests the String.IsNullOrWhiteSpace validation logic for Spread and All-In Cust. Rate fields
    /// </summary>
    class Program
    {
        static int passed = 0;
        static int failed = 0;

        static void Main(string[] args)
        {
            Console.WriteLine("TPP-9855 Validation Tests");
            Console.WriteLine("=========================");
            Console.WriteLine();
            Console.WriteLine("Testing String.IsNullOrWhiteSpace validation for Spread/All-In Cust. Rate fields");
            Console.WriteLine();

            // Test 1: Only Spread filled - should be valid
            TestValidation("1.5", "", true, "Only Spread filled");

            // Test 2: Only Rate filled - should be valid
            TestValidation("", "5.25", true, "Only Rate filled");

            // Test 3: Both filled - should fail validation
            TestValidation("1.5", "5.25", false, "Both filled");

            // Test 4: Neither filled - should fail validation
            TestValidation("", "", false, "Neither filled");

            // Test 5: Whitespace in Spread treated as empty (TPP-9855 fix)
            TestValidation("   ", "5.25", true, "Whitespace Spread + Rate (TPP-9855)");

            // Test 6: Tabs/spaces treated as empty (TPP-9855 fix)
            TestValidation("\t  ", "5.25", true, "Tab+Spaces Spread + Rate (TPP-9855)");

            // Test 7: Only whitespace in both - neither valid
            TestValidation(" ", "  ", false, "Only whitespace in both");

            // Test 8: Null handling
            TestValidation(null, "5.25", true, "Null Spread + Rate");

            // Test 9: Both null - neither valid
            TestValidation(null, null, false, "Both null");

            // Test 10: Mixed whitespace and valid value
            TestValidation("  \t\n  ", "3.75", true, "Complex whitespace Spread + Rate");

            Console.WriteLine();
            Console.WriteLine("=========================");
            Console.WriteLine(string.Format("Results: {0} passed, {1} failed", passed, failed));
            Console.WriteLine();

            if (failed > 0)
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine("TESTS FAILED");
            }
            else
            {
                Console.ForegroundColor = ConsoleColor.Green;
                Console.WriteLine("ALL TESTS PASSED");
            }
            Console.ResetColor();

            Console.WriteLine();
            Console.WriteLine("Press any key to exit...");
            Console.ReadKey();
        }

        /// <summary>
        /// Tests the validation logic that mirrors TPP-9855 changes in CalculatorsForm.vb
        /// Uses XOR logic: exactly one of spread or rate must be filled
        /// </summary>
        static void TestValidation(string spread, string rate, bool expectedValid, string testName)
        {
            // This mirrors the TPP-9855 validation logic from CalculatorsForm.vb
            bool spreadFilled = !string.IsNullOrWhiteSpace(spread);
            bool rateFilled = !string.IsNullOrWhiteSpace(rate);
            bool isValid = spreadFilled ^ rateFilled;  // XOR - exactly one must be filled

            bool testPassed = (isValid == expectedValid);

            if (testPassed)
            {
                passed++;
                Console.ForegroundColor = ConsoleColor.Green;
                Console.WriteLine(string.Format("  [PASS] {0}", testName));
            }
            else
            {
                failed++;
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine(string.Format("  [FAIL] {0} - Expected: {1}, Got: {2}", testName, expectedValid, isValid));
            }
            Console.ResetColor();
        }
    }
}
