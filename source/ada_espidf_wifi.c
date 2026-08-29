/*
 *  Copyright (C) 2026, Vadim Godunko
 *
 *  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 */

#include "esp_wifi.h"

int __ada_sizeof_wifi_config_t      = sizeof(wifi_config_t);
int __ada_sizeof_wifi_init_config_t = sizeof(wifi_init_config_t);

void __ada_WIFI_INIT_CONFIG_DEFAULT(wifi_init_config_t *cfg)
{
    *cfg = (wifi_init_config_t)WIFI_INIT_CONFIG_DEFAULT();
}