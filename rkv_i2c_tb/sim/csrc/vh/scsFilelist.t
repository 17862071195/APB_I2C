#include "stdio.h"
#ifdef __cplusplus
extern "C" {
#endif
extern char at_least_one_object_file;
extern void *kernel_scs_file_ht_new(const void *, int);
extern int kernel_scs_file_ht_get(void *, const char *, int *);
extern int  strcmp(const char*, const char*);
  typedef struct {
    char* dFileName;
  } lPkgFileInfoStruct;

  typedef struct {
    char* dFileName;
    char* dRealFileName;
    long dFileOffset;
    unsigned long dFileSize;
    int dFileModTime;
    unsigned int simFlag;
  } lFileInfoStruct;

static int lNumOfScsFiles;
  static lFileInfoStruct lFInfoArr[] = {
  {"synopsys_sim.setup_0", "./synopsys_sim.setup", 76398, 3459, 1671977626, 0},
  {"synopsys_sim.setup_1", "./synopsys_sim.setup", 79857, 3459, 1671977626, 0},
  {"synopsys_sim.setup_2", "/opt/synopsys/vcs/vcs-mx/O-2018.09-SP2/bin/synopsys_sim.setup", 83316, 3536, 1551421512, 0},
  {"linux64/packages/synopsys/lib/64/NOVAS__.sim", "", 0, 76398, 0, 0},
  {"linux64/packages/synopsys/lib/64/NOVAS.sim", "", 86852, 50089, 0, 0},
