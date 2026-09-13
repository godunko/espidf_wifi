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

void __ada_Get_wifi_sta_config_t_ssid(wifi_sta_config_t *conf, const char **data, size_t *maxlen)
{
    *data   = conf->ssid;
    *maxlen = sizeof(conf->ssid);
}

void __ada_Set_wifi_config_t_ap_authmode(wifi_ap_config_t *cfg, wifi_auth_mode_t to)
{
    cfg->authmode = to;
}

void __ada_Set_wifi_config_t_ap_max_connection(wifi_ap_config_t *cfg, uint8_t max)
{
    cfg->max_connection = max;
}

void __ada_Set_wifi_config_t_ap_password(wifi_ap_config_t *cfg, const char *pwd, int len)
{
    memset(cfg->password, 0, sizeof(cfg->password));
    memcpy(cfg->password, pwd, sizeof(cfg->password) < len ? sizeof(cfg->password) : len);
}

void __ada_Set_wifi_config_t_ap_pmf_cfg_required(wifi_ap_config_t *cfg, bool req)
{
    cfg->pmf_cfg.required = req;
}

void __ada_Set_wifi_config_t_ap_ssid(wifi_ap_config_t *cfg, const char *ssid, int len)
{
    memset(cfg->ssid, 0, sizeof(cfg->ssid));
    memcpy(cfg->ssid, ssid, sizeof(cfg->ssid) < len ? sizeof(cfg->ssid) : len);
    cfg->ssid_len = sizeof(cfg->ssid) < len ? sizeof(cfg->ssid) : len;
}

void __ada_Set_wifi_config_t_sta_password(wifi_sta_config_t *cfg, const char *pwd, int len)
{
    memset(cfg->password, 0, sizeof(cfg->password));
    memcpy(cfg->password, pwd, sizeof(cfg->password) < len ? sizeof(cfg->password) : len);
}

void __ada_Set_wifi_config_t_sta_ssid(wifi_sta_config_t *cfg, const char *ssid, int len)
{
    memset(cfg->ssid, 0, sizeof(cfg->ssid));
    memcpy(cfg->ssid, ssid, sizeof(cfg->ssid) < len ? sizeof(cfg->ssid) : len);
}

void __ada_Set_wifi_config_t_sta_threshold_authmode(wifi_sta_config_t *cfg, wifi_auth_mode_t to)
{
    cfg->threshold.authmode = to;
}

void __ada_Set_wifi_init_config_t_nvs_enable(wifi_init_config_t *cfg, bool to)
{
    cfg->nvs_enable = to;
}
