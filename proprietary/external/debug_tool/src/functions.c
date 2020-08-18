#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>

#include "functions.h"

void show_help() 
{
    printf("    USAGE:\n");
    printf("    -h Prints this help message.\n");
    printf("    -c Clean up the LOG directory.\n");
    printf("    -l Take logcat.\n");
    printf("    -d Take dmesg.\n");
    printf("    -b Take bugreport.\n");
    printf("    -g Get device properties.\n");
    printf("    -t Get last tombstones.\n");
    printf("    -s Change SELinux status.\n\n");
}

char *__exec_sh(char *cmd)
{
    FILE *fp;
    char buffer[256];
    size_t chread, alloc = 256, len = 0;
    char  *out   = malloc(alloc);

    if ((fp = popen(cmd, "r")) == NULL) return NULL;
 
    while ((chread = fread(buffer, 1, sizeof(buffer), fp)) != 0) {
        if (len + chread >= alloc) {
            alloc *= 2;
            out = realloc(out, alloc);
        }
        memmove(out + len, buffer, chread);
        len += chread;
    }

    pclose(fp);
    return out;
}

int __copy_folder(char *src, char *dest)
{
    char cmd[MAX_LENGHT];

    /* FIXME: Stop using system commands. This it's a security hole. */
    snprintf(cmd, 100, "cp -r %s %s/", src, dest);

    return system(cmd);
}

int write_int(char *file, int value)
{
    FILE *fp = fopen(file, "w");

    if (fp == NULL){
      printf("[-] Failed to open %s!\n", file);
      return 1;
   }

   printf("[?] Write %d to %s\n", value, file);
   fprintf(fp,"%d",value);

   fflush(fp);
   fclose(fp);

   return 0;
}

int find_file(char *path, char *file_name)
{
    int ret;
    char cmd[MAX_LENGHT];
    char *files;

    /* FIXME: Stop using pipe to list all the files */
    snprintf(cmd, 100, "ls %s/", path);
    files = __exec_sh(cmd);

#if 0
    printf("[DBG] PATH = %s\n", path);
    printf("[DBG] FILE NAME = %s\n", file_name);
    printf("[DBG] PRESENT FILES = %s", files);
#endif

    if (strstr(files, file_name) != NULL) return 1; else return 0;
}

