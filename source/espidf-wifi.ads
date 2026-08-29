--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

private with System.Storage_Elements;

package ESPIDF.WiFi is

   type wifi_init_config_t is limited private;

   function WIFI_INIT_CONFIG_DEFAULT return wifi_init_config_t;

   function esp_wifi_init (config : wifi_init_config_t) return esp_err_t
     with Import, Convention => C, External_Name => "esp_wifi_init";

   procedure esp_wifi_init (config : wifi_init_config_t);

private

   sizeof_wifi_init_config_t : constant int
      with Import, Convention => C,
           Link_Name => "__ada_sizeof_wifi_init_config_t";

   type wifi_init_config_t is
     new System.Storage_Elements.Storage_Array
       (1 .. System.Storage_Elements.Storage_Count
               (sizeof_wifi_init_config_t)) with Convention => C;

end ESPIDF.WiFi;
