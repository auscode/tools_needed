#include <windows.h>
#include <iostream>
#include <fstream>
#include <vector>

int main()
{
    // change the drivepath from using teh diskpart-> list disk-> find which drive you look for -> add in below path
    const wchar_t *drivePath = L"\\\\.\\PhysicalDrive3"; 
    // change teh start and end sector according to your file where it belongs there might be some place where you have to do the 
    // data runs and merging  multiple bin files to recreate a file 
    const long long startSector = 6250680;
    const long long endSector = 6308354;
    const int sectorSize = 512;

    HANDLE hDrive = CreateFileW(
        drivePath,
        GENERIC_READ,
        FILE_SHARE_READ | FILE_SHARE_WRITE,
        NULL,
        OPEN_EXISTING,
        0,
        NULL);

    if (hDrive == INVALID_HANDLE_VALUE)
    {
        std::cerr << "Error: cannot open drive. Run as Administrator.\n";
        return 1;
    }

    long long totalSectors = (endSector - startSector) + 1;
    long long totalBytes = totalSectors * sectorSize;
    std::vector<BYTE> buffer(totalBytes);

    LARGE_INTEGER li;
    li.QuadPart = startSector * sectorSize;
    if (SetFilePointerEx(hDrive, li, NULL, FILE_BEGIN) == 0)
    {
        std::cerr << "Error: seek failed.\n";
        CloseHandle(hDrive);
        return 1;
    }

    DWORD bytesRead = 0;
    if (!ReadFile(hDrive, buffer.data(), (DWORD)buffer.size(), &bytesRead, NULL))
    {
        std::cerr << "Error: read failed.\n";
        CloseHandle(hDrive);
        return 1;
    }

    CloseHandle(hDrive);

    // Write raw copy to file
    std::ofstream out("sector_copy.bin", std::ios::binary);
    out.write(reinterpret_cast<char *>(buffer.data()), bytesRead);
    out.close();

    std::cout << "Bit-for-bit copy saved to sector_copy.bin ("
              << bytesRead << " bytes)\n";
    return 0;
}
