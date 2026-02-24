#include "ProcessSQLCMDFile.h"

static const std::string LOG_FILE_PATH = "\\\\us.bank-dns.com\\NAS\\pri\\usbnet_dev\\db\\stage\\usbcommon\\251_NewUSBCommon.c_sql_nusb_i_ext251\\execsql.log";

ProcessSQLCMDFile::ProcessSQLCMDFile(void) :ProcessSQLCMD()
{

}

ProcessSQLCMDFile::ProcessSQLCMDFile(std::string sSERVER, std::string sDATABASE, std::string sSQL, std::string sOutputfile, bool binputfile, bool bHeaders, std::string sdelimiter,string sEnvironment, bool btrusted_auth, std::string sUsername, std::string sPassword) :
    ProcessSQLCMD(sSERVER, sDATABASE, sSQL, binputfile, bHeaders, sEnvironment, btrusted_auth, sUsername, sPassword)
{

    set_Delimiter(sdelimiter);
    set_OutputFilename(sOutputfile);
    set_ShowHeaders(bHeaders);
    set_Environment(sEnvironment);

}

ProcessSQLCMDFile::ProcessSQLCMDFile(std::string sSERVER, std::string sDATABASE, std::string sInputQueryFilename, std::string sOutputfile, bool bHeaders, std::string sdelimiter, string sEnvironment, bool btrusted_auth, std::string sUsername, std::string sPassword) :
    ProcessSQLCMD(sSERVER, sDATABASE, sInputQueryFilename, bHeaders, sEnvironment,  btrusted_auth, sUsername, sPassword)
{

    set_InputFilename(sInputQueryFilename);
    set_Delimiter(sdelimiter);
    set_OutputFilename(sOutputfile);
    set_ShowHeaders(bHeaders);
    set_Environment(sEnvironment);

}

int ProcessSQLCMDFile::ExecuteCMD(bool displayoutput)
{
    int iRet = 0;


    std::string tempfilename = get_OutputFilename_temp();

    std::string file_name = get_OutputFilename();

    SetConsoleOutputCP(CP_UTF8);

    std::system((_command + " > " + tempfilename).c_str());

    //************************* Remove later ********************************//
    Logger logger(LOG_FILE_PATH);
    logger.log(_command + " > " + tempfilename);
    //***********************************************************************//

    //if file file_name exists
    if (std::ifstream(file_name))
        iRet = std::remove(file_name.c_str());

    ReadTempFileAndModify(tempfilename, file_name);

    if (std::ifstream(tempfilename))
        iRet = std::remove(tempfilename.c_str());


    return iRet;

}

int ProcessSQLCMDFile::ReadTempFileAndModify(std::string sSourceFile, std::string sDestiation)
{
    // open the filename and display records

    std::ifstream file(sSourceFile);
    std::string str;
    std::string hold;
    std::string sNewFile = sDestiation;
    std::ofstream newfile(sNewFile);
    while (std::getline(file, str))
    {

        str = ReplaceNULLValuesWithSpaces(str);
        str = ReplaceInternalDelimiter(str);

        if (!IsThisLineAfterHeader(str))
        {
            // std::cout << str << std::endl;
            newfile << str << std::endl;
        }
    }
    newfile.close();
    file.close();
    return 0;

}

bool ProcessSQLCMDFile::IsThisLineAfterHeader(std::string _sLine)
{
    //Check to see if the string only has delimiter or -- 
    if (_sLine.find(m_sdelimiter) != std::string::npos && _sLine.find("----") != std::string::npos)
        return true; 
    else
        return false;
}

std::string ProcessSQLCMDFile::ReplaceInternalDelimiter(std::string sLine)
{
    std::string sNewLine = sLine;

    // Remove private delimieter from the end of the line if it exists
    if (sNewLine[sNewLine.length() - 1] == _delimiter[0])
        sNewLine = sNewLine.substr(0, sNewLine.length() - 1);

    if (_delimiter == m_sdelimiter) return sNewLine;



    size_t pos = sNewLine.find(_delimiter);

    while (pos != std::string::npos)
    {
        sNewLine.replace(pos, _delimiter.length(), m_sdelimiter);
        pos = sNewLine.find(_delimiter, pos + m_sdelimiter.length());
    }


    return sNewLine;
}
void ProcessSQLCMDFile::set_Delimiter(std::string sDelimiter)
{
    m_sdelimiter = sDelimiter;
}

void ProcessSQLCMDFile::set_ShowHeaders(bool _bShowHeaders)
{
    _bHeaders = _bShowHeaders;
}

void ProcessSQLCMDFile::set_OutputFilename(std::string sOutputfile)
{
    m_soutputfilename = sOutputfile;

    ProcessSQLCMD::set_OutputFilename(sOutputfile);

}

void ProcessSQLCMDFile::set_InputFilename(std::string sInputfile)
{
    m_sinputfilename = sInputfile;
}

void ProcessSQLCMDFile::set_Environment(std::string sEnvornment)
{
    m_sEnvironment = sEnvornment;
}


