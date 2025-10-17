# SSIS Script Task Breakpoint Fix – Binding Redirect Workaround

### Overview

In some Visual Studio 2019 SSIS environments (especially targeting SQL Server 2016), Script Task breakpoints may be ignored due to a version mismatch in the VSTA assemblies.  
This workaround adds a **binding redirect** so that the correct assembly version is loaded during debugging.

---

## 🧭 Steps

1. **Close Visual Studio 2019.**

2. **Locate the configuration file:**

   ```
   C:\Program Files (x86)\Microsoft Visual Studio\2019\<Edition>\Common7\IDE\CommonExtensions\Microsoft\SSIS\130\Binn\default.applocal.config
   ```

   Replace `<Edition>` with your installed edition, e.g. `Community`, `Professional`, or `Enterprise`.

3. **Backup the file** (copy it somewhere safe before editing).

4. **Edit the file** using Notepad (run as Administrator).

5. **Inside the `<runtime>` section**, add the following XML snippet
   under `<assemblyBinding>`:

   ```xml
   <dependentAssembly>
     <assemblyIdentity name="Microsoft.SqlServer.IntegrationServices.VSTA.VSTA16"
                       publicKeyToken="89845dcd8080cc91"
                       culture="neutral" />
     <bindingRedirect oldVersion="15.0.0.0" newVersion="15.100.0.0" />
   </dependentAssembly>
   ```

   If the file doesn’t already contain a `<runtime>` or `<assemblyBinding>` section,
   wrap it like this:

   ```xml
   <runtime>
     <assemblyBinding xmlns="urn:schemas-microsoft-com:asm.v1">
       <dependentAssembly>
         <assemblyIdentity name="Microsoft.SqlServer.IntegrationServices.VSTA.VSTA16"
                           publicKeyToken="89845dcd8080cc91"
                           culture="neutral" />
         <bindingRedirect oldVersion="15.0.0.0" newVersion="15.100.0.0" />
       </dependentAssembly>
     </assemblyBinding>
   </runtime>
   ```

6. **Save the file and restart Visual Studio 2019.**

7. **Rebuild your SSIS solution**, then debug again.

---

## ✅ Notes

- This redirect tells .NET to use the correct VSTA assembly (`15.100.0.0`)
  when SSIS expects version `15.0.0.0`.
- It only affects SSIS debugging sessions launched from Visual Studio.
- When Microsoft releases an updated SSIS Projects extension that fixes this,
  you can safely remove the manual redirect.
- Always run Visual Studio in **32-bit debug mode** for Script Task breakpoints:  
  `Project → Properties → Debugging → Run64BitRuntime = False`.

---

**Source:**  
Microsoft engineer _Wanxuan Ye (MSFT)_ – Visual Studio Developer Community response to SSIS Script Task breakpoint issue (2024).
