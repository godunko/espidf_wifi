--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

with ESPIDF.NETIF;

package ESPIDF.WiFi.Default is

   function esp_netif_create_default_wifi_sta
     return ESPIDF.NETIF.esp_netif_t_ptr
       with Import, Convention => C,
            External_Name => "esp_netif_create_default_wifi_sta";

end ESPIDF.WiFi.Default;
