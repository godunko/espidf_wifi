--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

with ESPIDF.NETIF;

package ESPIDF.WiFi.Default is

   function esp_netif_create_default_wifi_ap
     return ESPIDF.NETIF.esp_netif_t_ptr
       with Import, Convention => C,
            External_Name => "esp_netif_create_default_wifi_ap";

   function esp_netif_create_default_wifi_sta
     return ESPIDF.NETIF.esp_netif_t_ptr
       with Import, Convention => C,
            External_Name => "esp_netif_create_default_wifi_sta";

   procedure esp_netif_destroy_default_wifi
     (esp_netif : in out ESPIDF.NETIF.esp_netif_t_ptr);

end ESPIDF.WiFi.Default;
