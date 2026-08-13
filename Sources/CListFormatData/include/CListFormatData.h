#ifndef CListFormatData_h
#define CListFormatData_h

#include <stddef.h>

#define PATTERN_COUNT 344
#define LOCALE_COUNT 329

const char *listFormatPattern(int index);
const char *listFormatLocale(int index);
size_t listFormatPatternLength(int index);
size_t listFormatLocaleLength(int index);

#endif /* CListFormatData_h */
