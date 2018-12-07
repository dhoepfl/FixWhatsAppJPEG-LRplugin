#include <iostream>
#include <fstream>
#include <unistd.h>
#include <cstdint>
#include <sys/fcntl.h>
#include <sys/stat.h>
#include <sys/time.h>

int main(int argc, char *argv[])
{
   const char *infile = NULL;
   const char *outfile = NULL;
   bool verbose = false;
   bool usage = false;

   int opt;
   while ((opt = ::getopt(argc, argv, ":v")) != -1) {
      switch (opt)
      {
         case 'v':
            verbose = true;
            break;

         default:
            usage = true;
            break;
      }
   }

   if (optind+2 != argc) {
      usage = true;
   }

   if (usage) {
      std::cerr << "Usage: " << argv[0] << " [-v] <input> <output>" << std::endl;
      return -1;
   }
   infile = argv[optind];
   outfile = argv[optind+1];

#ifdef AT_FDCWD
   struct stat infileStat;
   if (0 != ::lstat(infile, &infileStat)) {
      std::cerr << "Failed to stat " << infile << std::endl;
      return -1;
   }
#endif

   std::ifstream is(infile, std::ifstream::binary);
   if (!is) {
      std::cerr << "Failed to open " << infile << std::endl;
      return -1;
   }

   is.seekg(0, is.end);
   ::uint64_t length = is.tellg();
   is.seekg(0, is.beg);

   if (verbose) { std::cout << "Reading from " << infile << " ..." << std::endl; }

   ::uint8_t * buffer = new ::uint8_t [length];

   is.read((char *)buffer, length);

   if (!is) {
      std::cerr << "Failed to read " << infile << std::endl;
      return -1;
   }
   is.close();

   if (verbose) { std::cout << "Read " << length << " bytes from " << infile << std::endl; }

   std::ofstream os(outfile, std::ofstream::out|std::ofstream::binary);
   if (!os) {
      std::cerr << "Failed to open " << outfile << std::endl;
      delete[] buffer;
      return -1;
   }

   if (verbose) { std::cout << "Writing to " << outfile << " ..." << std::endl; }
   ::uint64_t count = 0;
   ::uint64_t pos = 0;
   while (pos < length) {
      if (buffer[pos] == 0xff && buffer[pos+1] == 0xc4) {
         if (buffer[pos+2] != 0 || buffer[pos+3] != 2) {
            os.write((const char *) buffer+pos, 2 + (buffer[pos+2]<<8) + buffer[pos+3]);
            count += 2 + (buffer[pos+2]<<8) + buffer[pos+3];
         }
         pos += 2 + (buffer[pos+2]<<8) + buffer[pos+3];
      } else {
         ::uint64_t nextFF = pos+2;
         while (nextFF < length && buffer[nextFF] != 0xff) {
            nextFF++;
         }

         os.write((const char *) buffer+pos, nextFF-pos);
         count += nextFF-pos;
         pos = nextFF;
      }
   }
   if (!os) {
      std::cerr << "Failed to write" << std::endl;
      delete[] buffer;
      return -1;
   }
   os.close();

#ifdef AT_FDCWD
   struct timeval outfileTimespec[2];
   outfileTimespec[0].tv_sec = infileStat.st_atimespec.tv_sec;
   outfileTimespec[0].tv_usec = infileStat.st_atimespec.tv_nsec / 1000;
   outfileTimespec[1].tv_sec = infileStat.st_mtimespec.tv_sec;
   outfileTimespec[1].tv_usec = infileStat.st_mtimespec.tv_nsec / 1000;
   ::utimes(outfile, outfileTimespec);
#endif

   if (verbose) { std::cout << "Wrote " << count << " bytes to " << outfile << std::endl; }

   delete[] buffer;

   return 0;
}
