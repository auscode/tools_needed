#include <iostream>
#include <vector>
#include <string>
#include <windows.h>

bool clearSectorZeroWinAPI(int diskNumber)
{
    std::string diskPath = "\\\\.\\PhysicalDrive" + std::to_string(diskNumber);

    // Open disk with write permissions
    HANDLE hDisk = CreateFileA(
        diskPath.c_str(),
        GENERIC_READ | GENERIC_WRITE, // Both read and write permissions
        FILE_SHARE_READ | FILE_SHARE_WRITE,
        NULL,
        OPEN_EXISTING,
        0,
        NULL);

    if (hDisk == INVALID_HANDLE_VALUE)
    {
        std::cerr << "Failed to open disk. Error: " << GetLastError() << std::endl;
        return false;
    }

    // Create 512 bytes of zeros
    char zeroBuffer[512] = {0};
    DWORD bytesWritten;

    // Write to sector 0
    if (!WriteFile(hDisk, zeroBuffer, 512, &bytesWritten, NULL))
    {
        std::cerr << "Failed to write to disk. Error: " << GetLastError() << std::endl;
        CloseHandle(hDisk);
        return false;
    }

    CloseHandle(hDisk);

    if (bytesWritten == 512)
    {
        std::cout << "Successfully cleared sector 0!" << std::endl;
        return true;
    }
    else
    {
        std::cout << "Warning: Only " << bytesWritten << " bytes written." << std::endl;
        return false;
    }
}

int main()
{
    std::cout << "Disk Sector 0 Cleaner" << std::endl;
    std::cout << "======================" << std::endl;

    // Test which drives we can access
    std::vector<int> availableDrives;

    for (int i = 0; i < 10; i++)
    {
        std::string path = "\\\\.\\PhysicalDrive" + std::to_string(i);
        HANDLE h = CreateFileA(path.c_str(), GENERIC_READ,
                               FILE_SHARE_READ | FILE_SHARE_WRITE,
                               NULL, OPEN_EXISTING, 0, NULL);

        if (h != INVALID_HANDLE_VALUE)
        {
            std::cout << "Drive " << i << ": Available" << std::endl;
            availableDrives.push_back(i);
            CloseHandle(h);
        }
    }

    if (availableDrives.empty())
    {
        std::cout << "No drives found. Run as Administrator!" << std::endl;
        std::cin.get();
        return 1;
    }

    std::cout << "\nEnter drive number to clear: ";
    int driveNum;
    std::cin >> driveNum;

    std::cout << "WARNING: This will destroy sector 0 of drive " << driveNum << std::endl;
    std::cout << "Type 'ERASE' to confirm: ";
    std::string confirm;
    std::cin >> confirm;

    if (confirm == "ERASE")
    {
        if (clearSectorZeroWinAPI(driveNum))
        {
            std::cout << "Done!" << std::endl;
        }
        else
        {
            std::cout << "Failed!" << std::endl;
        }
    }
    else
    {
        std::cout << "Cancelled." << std::endl;
    }

    std::cout << "\nPress Enter to exit...";
    std::cin.ignore();
    std::cin.get();

    return 0;
}
