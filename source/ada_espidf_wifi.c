/*
 *  Copyright (C) 2026, Vadim Godunko
 *
 *  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 */

#include <string.h>
#include "esp_wifi.h"

int __ada_sizeof_wifi_config_t      = sizeof(wifi_config_t);
int __ada_sizeof_wifi_init_config_t = sizeof(wifi_init_config_t);

void __ada_WIFI_INIT_CONFIG_DEFAULT(wifi_init_config_t *cfg)
{
    *cfg = (wifi_init_config_t)WIFI_INIT_CONFIG_DEFAULT();
}

void __ada_Set_wifi_config_t_ap_authmode(wifi_config_t *cfg, wifi_auth_mode_t to)
{
    cfg->ap.authmode = to;
}

void __ada_Set_wifi_config_t_ap_ssid(wifi_config_t *cfg, const char *ssid, int len)
{
    memset(cfg->ap.ssid, 0, sizeof(cfg->ap.ssid));
    memcpy(cfg->ap.ssid, ssid, sizeof(cfg->ap.ssid) < len ? sizeof(cfg->ap.ssid) : len);
    cfg->ap.ssid_len = sizeof(cfg->ap.ssid) < len ? sizeof(cfg->ap.ssid) : len;
}

void __ada_Set_wifi_config_t_ap_password(wifi_config_t *cfg, const char *pwd, int len)
{
    memset(cfg->ap.password, 0, sizeof(cfg->ap.password));
    memcpy(cfg->ap.password, pwd, sizeof(cfg->ap.password) < len ? sizeof(cfg->ap.password) : len);
}

void __ada_Set_wifi_config_t_sta_password(wifi_config_t *cfg, const char *pwd, int len)
{
    memset(cfg->sta.password, 0, sizeof(cfg->sta.password));
    memcpy(cfg->sta.password, pwd, sizeof(cfg->sta.password) < len ? sizeof(cfg->sta.password) : len);
}

void __ada_Set_wifi_config_t_sta_ssid(wifi_config_t *cfg, const char *ssid, int len)
{
    memset(cfg->sta.ssid, 0, sizeof(cfg->sta.ssid));
    memcpy(cfg->sta.ssid, ssid, sizeof(cfg->sta.ssid) < len ? sizeof(cfg->sta.ssid) : len);
}

void __ada_Set_wifi_config_t_sta_threshold_authmode(wifi_config_t *cfg, wifi_auth_mode_t to)
{
    cfg->sta.threshold.authmode = to;
}

void __ada_Set_wifi_init_config_t_nvs_enable(wifi_init_config_t *cfg, bool to)
{
    cfg->nvs_enable = to;
}
