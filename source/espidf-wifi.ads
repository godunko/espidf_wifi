--
--  Copyright (C) 2026, Vadim Godunko
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

pragma Ada_2022;
pragma Extensions_Allowed (On);
--  Aspect `Finalizable` is used to initialize objects automaically

private with System.Storage_Elements;

with ESPIDF.C_Strings;
with ESPIDF.Event;

package ESPIDF.WiFi is

   ESP_ERR_WIFI_NOT_INIT          : constant esp_err_t := 16#3001#;
   --  WiFi driver was not installed by `esp_wifi_init`
   ESP_ERR_WIFI_NOT_STARTED       : constant esp_err_t := 16#3002#;
   --  WiFi driver was not started by `esp_wifi_start`
   ESP_ERR_WIFI_NOT_STOPPED       : constant esp_err_t := 16#3003#;
   --  WiFi driver was not stopped by `esp_wifi_stop`
   ESP_ERR_WIFI_IF                : constant esp_err_t := 16#3004#;
   --  WiFi interface error
   ESP_ERR_WIFI_MODE              : constant esp_err_t := 16#3005#;
   --  WiFi mode error
   ESP_ERR_WIFI_STATE             : constant esp_err_t := 16#3006#;
   --  WiFi internal state error
   ESP_ERR_WIFI_CONN              : constant esp_err_t := 16#3007#;
   --  WiFi internal control block of station or soft-AP error
   ESP_ERR_WIFI_NVS               : constant esp_err_t := 16#3008#;
   --  WiFi internal NVS module error
   ESP_ERR_WIFI_MAC               : constant esp_err_t := 16#3009#;
   --  MAC address is invalid
   ESP_ERR_WIFI_SSID              : constant esp_err_t := 16#300A#;
   --  SSID is invalid
   ESP_ERR_WIFI_PASSWORD          : constant esp_err_t := 16#300B#;
   --  Password is invalid
   ESP_ERR_WIFI_TIMEOUT           : constant esp_err_t := 16#300C#;
   --  Timeout error
   ESP_ERR_WIFI_WAKE_FAIL         : constant esp_err_t := 16#300D#;
   --  WiFi is in sleep state (RF closed) and wakeup fail
   ESP_ERR_WIFI_WOULD_BLOCK       : constant esp_err_t := 16#300E#;
   --  The caller would block
   ESP_ERR_WIFI_NOT_CONNECT       : constant esp_err_t := 16#300F#;
   --  Station still in disconnect status
   ESP_ERR_WIFI_POST              : constant esp_err_t := 16#3012#;
   --  Failed to post the event to WiFi task
   ESP_ERR_WIFI_INIT_STATE        : constant esp_err_t := 16#3013#;
   --  Invalid WiFi state when init/deinit is called
   ESP_ERR_WIFI_STOP_STATE        : constant esp_err_t := 16#3014#;
   --  Returned when WiFi is stopping
   ESP_ERR_WIFI_NOT_ASSOC         : constant esp_err_t := 16#3015#;
   --  The WiFi connection is not associated
   ESP_ERR_WIFI_TX_DISALLOW       : constant esp_err_t := 16#3016#;
   --  The WiFi TX is disallowed
   ESP_ERR_WIFI_TWT_FULL          : constant esp_err_t := 16#3017#;
   --  No available flow id
   ESP_ERR_WIFI_TWT_SETUP_TIMEOUT : constant esp_err_t := 16#3018#;
   --  Timeout of receiving twt setup response frame, timeout times can be
   --  set during twt setup
   ESP_ERR_WIFI_TWT_SETUP_TXFAIL  : constant esp_err_t := 16#3019#;
   --  TWT setup frame tx failed
   ESP_ERR_WIFI_TWT_SETUP_REJECT  : constant esp_err_t := 16#301A#;
   --  The twt setup request was rejected by the AP
   ESP_ERR_WIFI_DISCARD           : constant esp_err_t := 16#301B#;
   --  Discard frame
   ESP_ERR_WIFI_ROC_IN_PROGRESS   : constant esp_err_t := 16#301C#;
   --  ROC op is in progress

   type wifi_mode_t is
     (WIFI_MODE_NULL,
      WIFI_MODE_STA,
      WIFI_MODE_AP,
      WIFI_MODE_APSTA,
      WIFI_MODE_NAN) with Convention => C;
   --  Wi-Fi mode type.
   --  @enum WIFI_MODE_NULL Null mode
   --  @enum WIFI_MODE_STA Wi-Fi station mode
   --  @enum WIFI_MODE_AP Wi-Fi soft-AP mode
   --  @enum WIFI_MODE_APSTA Wi-Fi station + soft-AP mode
   --  @enum WIFI_MODE_NAN Wi-Fi NAN mode

   type wifi_interface_t is
     (WIFI_IF_STA,
      WIFI_IF_AP,
      WIFI_IF_NAN) with Convention => C;
   --  Wi-Fi interface type.
   --  @enum WIFI_IF_STA Station interface
   --  @enum WIFI_IF_AP Soft-AP interface
   --  @enum WIFI_IF_NAN NAN interface

   type wifi_init_config_t is limited private;
   --  WiFi stack configuration parameters passed to `esp_wifi_init` call.
   --
   --  Objects initialized using WIFI_INIT_CONFIG_DEFAULT macro automatically.

   procedure Set_nvs_enable
     (cfg : in out wifi_init_config_t; To : Boolean);
   --  Set WiFi NVS flash enable flag.
   --  @param cfg WiFi stack configuration parameters to modify.
   --  @param To WiFi NVS flash enable flag.

   type wifi_auth_mode_t is
     (WIFI_AUTH_OPEN,
      WIFI_AUTH_WEP,
      WIFI_AUTH_WPA_PSK,
      WIFI_AUTH_WPA2_PSK,
      WIFI_AUTH_WPA_WPA2_PSK,
      WIFI_AUTH_ENTERPRISE,
      WIFI_AUTH_WPA3_PSK,
      WIFI_AUTH_WPA2_WPA3_PSK,
      WIFI_AUTH_WAPI_PSK,
      WIFI_AUTH_OWE,
      WIFI_AUTH_WPA3_ENT_192,
      WIFI_AUTH_DUMMY_1,
      WIFI_AUTH_DUMMY_2,
      WIFI_AUTH_DPP,
      WIFI_AUTH_WPA3_ENTERPRISE,
      WIFI_AUTH_WPA2_WPA3_ENTERPRISE,
      WIFI_AUTH_WPA_ENTERPRISE) with Convention => C;
   --  Wi-Fi authmode type.
   --
   --  Strength of authmodes:
   --    - Personal Networks: OPEN < WEP < WPA_PSK < OWE < WPA2_PSK =
   --      WPA_WPA2_PSK < WAPI_PSK < WPA3_PSK = WPA2_WPA3_PSK = DPP
   --    - Enterprise Networks: `WIFI_AUTH_WPA_ENTERPRISE` <
   --      `WIFI_AUTH_WPA2_ENTERPRISE` < `WIFI_AUTH_WPA3_ENTERPRISE` =
   --      `WIFI_AUTH_WPA2_WPA3_ENTERPRISE` < `WIFI_AUTH_WPA3_ENT_192`
   --  @enum WIFI_AUTH_OPEN Authenticate mode: open
   --  @enum WIFI_AUTH_WEP Authenticate mode: WEP
   --  @enum WIFI_AUTH_WPA_PSK Authenticate mode: WPA_PSK
   --  @enum WIFI_AUTH_WPA2_PSK Authenticate mode: WPA2_PSK
   --  @enum WIFI_AUTH_WPA_WPA2_PSK Authenticate mode: WPA_WPA2_PSK
   --  @enum WIFI_AUTH_ENTERPRISE
   --    Authenticate mode: Wi-Fi EAP security, treated the same as
   --    `WIFI_AUTH_WPA2_ENTERPRISE`
   --  @enum WIFI_AUTH_WPA3_PSK Authenticate mode: WPA3_PSK
   --  @enum WIFI_AUTH_WPA2_WPA3_PSK Authenticate mode: WPA2_WPA3_PSK
   --  @enum WIFI_AUTH_WAPI_PSK Authenticate mode: WAPI_PSK
   --  @enum WIFI_AUTH_OWE Authenticate mode: OWE
   --  @enum WIFI_AUTH_WPA3_ENT_192
   --    Authenticate mode: WPA3_ENT_SUITE_B_192_BIT
   --  @enum WIFI_AUTH_DUMMY_1
   --    Placeholder: Previously used by WIFI_AUTH_WPA3_EXT_PSK
   --  @enum WIFI_AUTH_DUMMY_2
   --    Placeholder: Previously used by WIFI_AUTH_WPA3_EXT_PSK_MIXED_MODE
   --  @enum WIFI_AUTH_DPP Authenticate mode: DPP
   --  @enum WIFI_AUTH_WPA3_ENTERPRISE
   --    Authenticate mode: WPA3-Enterprise Only Mode
   --  @enum WIFI_AUTH_WPA2_WPA3_ENTERPRISE
   --    Authenticate mode: WPA3-Enterprise Transition Mode
   --  @enum WIFI_AUTH_WPA_ENTERPRISE
   --    Authenticate mode: WPA-Enterprise security
   function WIFI_AUTH_WPA2_ENTERPRISE return wifi_auth_mode_t is
     (WIFI_AUTH_ENTERPRISE);
   --  Authenticate mode: WPA2-Enterprise security

   type wifi_storage_t is
     (WIFI_STORAGE_FLASH,
      WIFI_STORAGE_RAM) with Convention => C;
   --  Wi-Fi storage type.
   --  @enum WIFI_STORAGE_FLASH
   --    All configuration will store in both memory and flash
   --  @enum WIFI_STORAGE_RAM All configuration will only store in the memory

   ------------------------------------------------
   --  `wifi_config_t` is split into STA/AP/NAN  --
   ------------------------------------------------

   type wifi_ap_config_t is limited private;
   --  Soft-AP configuration settings for the device.

   procedure Set_ssid
     (Self : in out wifi_ap_config_t;
      To   : ESPIDF.C_Strings.char_array_string)
      with Pre => To'Length in 0 .. 33;
   --  Set SSID of soft-AP.
   --
   --  Length of the SSID is set according to the length of the given
   --  string.
   --  @param Self Soft-AP configuration to modify.
   --  @param To SSID of soft-AP.

   procedure Set_password
     (Self : in out wifi_ap_config_t;
      To   : ESPIDF.C_Strings.char_array_string)
      with Pre => To'Length in 0 .. 65;
   --  Set password of soft-AP.
   --  @param Self Soft-AP configuration to modify.
   --  @param To Password of soft-AP.

   procedure Set_authmode
     (Self : in out wifi_ap_config_t;
      To   : wifi_auth_mode_t);
   --  Set auth mode of soft-AP.
   --  @param Self Soft-AP configuration to modify.
   --  @param To
   --    Auth mode of soft-AP. Do not support AUTH_WEP, AUTH_WAPI_PSK and
   --    AUTH_OWE in soft-AP mode. When the auth mode is set to WPA2_PSK,
   --    WPA2_WPA3_PSK or WPA3_PSK, the pairwise cipher will be overwritten
   --    with WIFI_CIPHER_TYPE_CCMP by default, unless explicitly set.

   procedure Set_max_connection
     (Self : in out wifi_ap_config_t;
      To   : uint8_t);
   --  Set max number of stations allowed to connect in.
   --  @param Self Soft-AP configuration to modify.
   --  @param To
   --    Max number of stations allowed to connect in. Please note that
   --    soft-AP and ESP-NOW share the same encryption hardware keys, so the
   --    max_connection parameter will be affected by
   --    CONFIG_ESP_WIFI_ESPNOW_MAX_ENCRYPT_NUM.

   procedure Set_pmf_cfg_required
     (Self : in out wifi_ap_config_t;
      To   : Boolean);
   --  Set whether Protected Management Frame is required.
   --  @param Self Soft-AP configuration to modify.
   --  @param To
   --    Advertises that Protected Management Frame is required. Device will
   --    not associate to non-PMF capable devices.

   type wifi_sta_config_t is limited private;
   --  STA configuration settings for the device.

   function Get_ssid
     (Self : wifi_sta_config_t) return ESPIDF.C_Strings.char_array_string;
   --  Get SSID of target AP.
   --  @param Self STA configuration.
   --  @return SSID of target AP.

   procedure Set_ssid
     (Self : in out wifi_sta_config_t;
      To   : ESPIDF.C_Strings.char_array_string)
      with Pre => To'Length in 0 .. 33;
   --  Set SSID of target AP.
   --  @param Self STA configuration to modify.
   --  @param To SSID of target AP.

   procedure Set_password
     (Self : in out wifi_sta_config_t;
      To   : ESPIDF.C_Strings.char_array_string)
      with Pre => To'Length in 0 .. 65;
   --  Set password of target AP.
   --  @param Self STA configuration to modify.
   --  @param To Password of target AP.

   procedure Set_threshold_authmode
     (Self : in out wifi_sta_config_t;
      To   : wifi_auth_mode_t);
   --  Set the weakest authentication mode to accept when scanning for Wi-Fi
   --  during connection.
   --
   --  When scan threshold is set, only APs which have an auth mode that is
   --  more secure than the selected auth mode and a signal stronger than
   --  the minimum RSSI will be used.
   --  @param Self STA configuration to modify.
   --  @param To
   --    The weakest authentication mode to accept when scanning for Wi-Fi
   --    during connection.
   --    Note: In case this value is not set and password is set as per WPA2
   --    standards (password len >= 8), it will be defaulted to WPA2 and
   --    device won't connect to deprecated WEP/WPA networks. Please set auth
   --    mode threshold as `WIFI_AUTH_WEP`/`WIFI_AUTH_WPA_PSK` to connect to
   --    WEP/WPA networks.
   --    If this is set to a mixed mode (for example, WPA_WPA2 or WPA2_WPA3),
   --    the minimum mode becomes the stronger of the two. For example,
   --    WPA_WPA2 becomes WPA2, and WPA2_WPA3 becomes WPA3. See
   --    `wifi_auth_mode_t` for details on relative strengths.

   WIFI_EVENT : constant ESPIDF.Event.esp_event_base_t
     with Import, Convention => C, External_Name => "WIFI_EVENT";
   --  Wi-Fi event base declaration

   type wifi_event_t is new int32_t;
   --  Wi-Fi event declarations.

   WIFI_EVENT_WIFI_READY                 : constant wifi_event_t := 0;
   --  Wi-Fi ready
   WIFI_EVENT_SCAN_DONE                  : constant wifi_event_t := 1;
   --  Finished scanning AP
   WIFI_EVENT_STA_START                  : constant wifi_event_t := 2;
   --  Station start
   WIFI_EVENT_STA_STOP                   : constant wifi_event_t := 3;
   --  Station stop
   WIFI_EVENT_STA_CONNECTED              : constant wifi_event_t := 4;
   --  Station connected to AP
   WIFI_EVENT_STA_DISCONNECTED           : constant wifi_event_t := 5;
   --  Station disconnected from AP
   WIFI_EVENT_STA_AUTHMODE_CHANGE        : constant wifi_event_t := 6;
   --  The auth mode of AP connected by device's station changed
   WIFI_EVENT_STA_WPS_ER_SUCCESS         : constant wifi_event_t := 7;
   --  Station WPS succeeds in enrollee mode
   WIFI_EVENT_STA_WPS_ER_FAILED          : constant wifi_event_t := 8;
   --  Station WPS fails in enrollee mode
   WIFI_EVENT_STA_WPS_ER_TIMEOUT         : constant wifi_event_t := 9;
   --  Station WPS timeout in enrollee mode
   WIFI_EVENT_STA_WPS_ER_PIN             : constant wifi_event_t := 10;
   --  Station WPS pin code in enrollee mode
   WIFI_EVENT_STA_WPS_ER_PBC_OVERLAP     : constant wifi_event_t := 11;
   --  Station WPS overlap in enrollee mode
   WIFI_EVENT_AP_START                   : constant wifi_event_t := 12;
   --  Soft-AP start
   WIFI_EVENT_AP_STOP                    : constant wifi_event_t := 13;
   --  Soft-AP stop
   WIFI_EVENT_AP_STACONNECTED            : constant wifi_event_t := 14;
   --  A station connected to Soft-AP
   WIFI_EVENT_AP_STADISCONNECTED         : constant wifi_event_t := 15;
   --  A station disconnected from Soft-AP
   WIFI_EVENT_AP_PROBEREQRECVED          : constant wifi_event_t := 16;
   --  Receive probe request packet in soft-AP interface
   WIFI_EVENT_FTM_REPORT                 : constant wifi_event_t := 17;
   --  Receive report of FTM procedure
   WIFI_EVENT_STA_BSS_RSSI_LOW           : constant wifi_event_t := 18;
   --  AP's RSSI crossed configured threshold
   WIFI_EVENT_ACTION_TX_STATUS           : constant wifi_event_t := 19;
   --  Status indication of Action Tx operation
   WIFI_EVENT_ROC_DONE                   : constant wifi_event_t := 20;
   --  Remain-on-Channel operation complete
   WIFI_EVENT_STA_BEACON_TIMEOUT         : constant wifi_event_t := 21;
   --  Station beacon timeout
   WIFI_EVENT_CONNECTIONLESS_MODULE_WAKE_INTERVAL_START :
                                           constant wifi_event_t := 22;
   --  Connectionless module wake interval start
   WIFI_EVENT_AP_WPS_RG_SUCCESS          : constant wifi_event_t := 23;
   --  Soft-AP wps succeeds in registrar mode
   WIFI_EVENT_AP_WPS_RG_FAILED           : constant wifi_event_t := 24;
   --  Soft-AP wps fails in registrar mode
   WIFI_EVENT_AP_WPS_RG_TIMEOUT          : constant wifi_event_t := 25;
   --  Soft-AP wps timeout in registrar mode
   WIFI_EVENT_AP_WPS_RG_PIN              : constant wifi_event_t := 26;
   --  Soft-AP wps pin code in registrar mode
   WIFI_EVENT_AP_WPS_RG_PBC_OVERLAP      : constant wifi_event_t := 27;
   --  Soft-AP wps overlap in registrar mode
   WIFI_EVENT_ITWT_SETUP                 : constant wifi_event_t := 28;
   --  iTWT setup
   WIFI_EVENT_ITWT_TEARDOWN              : constant wifi_event_t := 29;
   --  iTWT teardown
   WIFI_EVENT_ITWT_PROBE                 : constant wifi_event_t := 30;
   --  iTWT probe
   WIFI_EVENT_ITWT_SUSPEND               : constant wifi_event_t := 31;
   --  iTWT suspend
   WIFI_EVENT_TWT_WAKEUP                 : constant wifi_event_t := 32;
   --  TWT wakeup
   WIFI_EVENT_BTWT_SETUP                 : constant wifi_event_t := 33;
   --  bTWT setup
   WIFI_EVENT_BTWT_TEARDOWN              : constant wifi_event_t := 34;
   --  bTWT teardown
   WIFI_EVENT_NAN_SYNC_STARTED           : constant wifi_event_t := 35;
   --  NAN Synchronization Discovery has started
   WIFI_EVENT_NAN_SYNC_STOPPED           : constant wifi_event_t := 36;
   --  NAN Synchronization Discovery has stopped
   WIFI_EVENT_NAN_SVC_MATCH              : constant wifi_event_t := 37;
   --  NAN Service Discovery match found
   WIFI_EVENT_NAN_REPLIED                : constant wifi_event_t := 38;
   --  Replied to a NAN peer with Service Discovery match
   WIFI_EVENT_NAN_RECEIVE                : constant wifi_event_t := 39;
   --  Received a Follow-up message
   WIFI_EVENT_NDP_INDICATION             : constant wifi_event_t := 40;
   --  Received NDP Request from a NAN Peer
   WIFI_EVENT_NDP_CONFIRM                : constant wifi_event_t := 41;
   --  NDP Confirm Indication
   WIFI_EVENT_NDP_TERMINATED             : constant wifi_event_t := 42;
   --  NAN Datapath terminated indication
   WIFI_EVENT_HOME_CHANNEL_CHANGE        : constant wifi_event_t := 43;
   --  Wi-Fi home channel change, doesn't occur when scanning
   WIFI_EVENT_STA_NEIGHBOR_REP           : constant wifi_event_t := 44;
   --  Received Neighbor Report response
   WIFI_EVENT_AP_WRONG_PASSWORD          : constant wifi_event_t := 45;
   --  A station tried to connect with wrong password
   WIFI_EVENT_STA_BEACON_OFFSET_UNSTABLE : constant wifi_event_t := 46;
   --  Station sampled beacon offset unstable
   WIFI_EVENT_DPP_URI_READY              : constant wifi_event_t := 47;
   --  DPP URI is ready through Bootstrapping
   WIFI_EVENT_DPP_CFG_RECVD              : constant wifi_event_t := 48;
   --  Config received via DPP Authentication
   WIFI_EVENT_DPP_FAILED                 : constant wifi_event_t := 49;
   --  DPP failed

   function esp_wifi_init (config : wifi_init_config_t) return esp_err_t
     with Import, Convention => C, External_Name => "esp_wifi_init";
   --  Initialize WiFi.
   --
   --  Allocate resource for WiFi driver, such as WiFi control structure,
   --  RX/TX buffer, WiFi NVS structure etc. This WiFi also starts WiFi task.
   --
   --  Note: This API must be called before all other WiFi API can be called.
   --
   --  Note: Objects of `wifi_init_config_t` type are initialized to default
   --  values by WIFI_INIT_CONFIG_DEFAULT macro automatically, this can
   --  guarantee all the fields get correct value when more fields are added
   --  into `wifi_init_config_t` in future release. If you want to set your
   --  own initial values, overwrite the default values.
   --  @param config
   --    WiFi initialized configuration structure; can be a temporary
   --    variable.
   --  @return
   --    - `ESP_OK` if WiFi was initialized successfully
   --    - `ESP_ERR_NO_MEM` if out of memory
   --    - other error codes, see `esp_err.h`

   procedure esp_wifi_init (config : wifi_init_config_t);
   --  Initialize WiFi.
   --
   --  Allocate resource for WiFi driver, such as WiFi control structure,
   --  RX/TX buffer, WiFi NVS structure etc. This WiFi also starts WiFi task.
   --
   --  Note: This API must be called before all other WiFi API can be called.
   --
   --  Note: Objects of `wifi_init_config_t` type are initialized to default
   --  values by WIFI_INIT_CONFIG_DEFAULT macro automatically, this can
   --  guarantee all the fields get correct value when more fields are added
   --  into `wifi_init_config_t` in future release. If you want to set your
   --  own initial values, overwrite the default values.
   --  @param config
   --    WiFi initialized configuration structure; can be a temporary
   --    variable.
   --  @raise ESPIDF_Error raised on error:
   --    - `ESP_ERR_NO_MEM` if out of memory
   --    - other error codes, see `esp_err.h`

   function esp_wifi_set_mode (mode : wifi_mode_t) return esp_err_t
     with Import, Convention => C, External_Name => "esp_wifi_set_mode";
   --  Set the WiFi operating mode.
   --
   --  Set the WiFi operating mode as station, soft-AP, station+soft-AP or
   --  NAN. The default mode is station mode.
   --  @param mode WiFi operating mode
   --  @return
   --    - `ESP_OK` if WiFi operating mode was set successfully
   --    - `ESP_ERR_WIFI_NOT_INIT` if WiFi is not initialized by
   --      `esp_wifi_init`
   --    - `ESP_ERR_INVALID_ARG` if argument is invalid
   --    - other error codes, see `esp_err.h`

   procedure esp_wifi_set_mode (mode : wifi_mode_t);
   --  Set the WiFi operating mode.
   --
   --  Set the WiFi operating mode as station, soft-AP, station+soft-AP or
   --  NAN. The default mode is station mode.
   --  @param mode WiFi operating mode
   --  @raise ESPIDF_Error raised on error:
   --    - `ESP_ERR_WIFI_NOT_INIT` if WiFi is not initialized by
   --      `esp_wifi_init`
   --    - `ESP_ERR_INVALID_ARG` if argument is invalid
   --    - other error codes, see `esp_err.h`

   function esp_wifi_get_config
     (conf : out wifi_ap_config_t) return esp_err_t;
   --  Get configuration of soft-AP interface.
   --
   --  `iface` parameter is implicit in the specialized functions
   --  @param conf soft-AP configuration
   --  @return
   --    - `ESP_OK` if soft-AP configuration was retrieved successfully
   --    - `ESP_ERR_WIFI_NOT_INIT` if WiFi is not initialized by
   --      `esp_wifi_init`
   --    - `ESP_ERR_INVALID_ARG` if argument is invalid
   --    - `ESP_ERR_WIFI_IF` if interface is invalid
   function esp_wifi_get_config
     (conf : out wifi_sta_config_t) return esp_err_t;
   --  Get configuration of station interface.
   --
   --  `iface` parameter is implicit in the specialized functions
   --  @param conf station configuration
   --  @return
   --    - `ESP_OK` if station configuration was retrieved successfully
   --    - `ESP_ERR_WIFI_NOT_INIT` if WiFi is not initialized by
   --      `esp_wifi_init`
   --    - `ESP_ERR_INVALID_ARG` if argument is invalid
   --    - `ESP_ERR_WIFI_IF` if interface is invalid

   procedure esp_wifi_get_config (conf : out wifi_ap_config_t);
   --  Get configuration of soft-AP interface.
   --
   --  `iface` parameter is implicit in the specialized procedures
   --  @param conf soft-AP configuration
   --  @raise ESPIDF_Error raised on error:
   --    - `ESP_ERR_WIFI_NOT_INIT` if WiFi is not initialized by
   --      `esp_wifi_init`
   --    - `ESP_ERR_INVALID_ARG` if argument is invalid
   --    - `ESP_ERR_WIFI_IF` if interface is invalid
   procedure esp_wifi_get_config (conf : out wifi_sta_config_t);
   --  Get configuration of station interface.
   --
   --  `iface` parameter is implicit in the specialized procedures
   --  @param conf station configuration
   --  @raise ESPIDF_Error raised on error:
   --    - `ESP_ERR_WIFI_NOT_INIT` if WiFi is not initialized by
   --      `esp_wifi_init`
   --    - `ESP_ERR_INVALID_ARG` if argument is invalid
   --    - `ESP_ERR_WIFI_IF` if interface is invalid

   function esp_wifi_set_config
     (conf : in out wifi_ap_config_t) return esp_err_t;
   --  Set the configuration of the soft-AP.
   --
   --  Note: This API can be called only when soft-AP interface is enabled,
   --  otherwise, API fail.
   --
   --  Note: ESP devices are limited to only one channel, so when in the
   --  soft-AP+station mode, the soft-AP will adjust its channel
   --  automatically to be the same as the channel of the station.
   --
   --  Note: The configuration will be stored in NVS.
   --
   --  `iface` parameter is implicit in the specialized functions
   --  @param conf soft-AP configuration
   --  @return
   --    - `ESP_OK` if soft-AP configuration was set successfully
   --    - `ESP_ERR_WIFI_NOT_INIT` if WiFi is not initialized by
   --      `esp_wifi_init`
   --    - `ESP_ERR_INVALID_ARG` if argument is invalid
   --    - `ESP_ERR_WIFI_IF` if interface is invalid
   --    - `ESP_ERR_WIFI_MODE` if mode is invalid
   --    - `ESP_ERR_WIFI_PASSWORD` if password is invalid
   --    - `ESP_ERR_WIFI_NVS` if WiFi internal NVS error occurs
   --    - `ESP_ERR_WIFI_STATE` if WiFi is still connecting when
   --      `esp_wifi_set_config` is invoked
   --    - other error codes, see `esp_err.h`
   function esp_wifi_set_config
     (conf : in out wifi_sta_config_t) return esp_err_t;
   --  Set the configuration of the station.
   --
   --  Note: This API can be called only when station interface is enabled,
   --  otherwise, API fail.
   --
   --  Note: ESP devices are limited to only one channel, so when in the
   --  soft-AP+station mode, the soft-AP will adjust its channel
   --  automatically to be the same as the channel of the station.
   --
   --  Note: The configuration will be stored in NVS.
   --
   --  `iface` parameter is implicit in the specialized functions
   --  @param conf station configuration
   --  @return
   --    - `ESP_OK` if station configuration was set successfully
   --    - `ESP_ERR_WIFI_NOT_INIT` if WiFi is not initialized by
   --      `esp_wifi_init`
   --    - `ESP_ERR_INVALID_ARG` if argument is invalid
   --    - `ESP_ERR_WIFI_IF` if interface is invalid
   --    - `ESP_ERR_WIFI_MODE` if mode is invalid
   --    - `ESP_ERR_WIFI_PASSWORD` if password is invalid
   --    - `ESP_ERR_WIFI_NVS` if WiFi internal NVS error occurs
   --    - `ESP_ERR_WIFI_STATE` if WiFi is still connecting when
   --      `esp_wifi_set_config` is invoked
   --    - other error codes, see `esp_err.h`

   procedure esp_wifi_set_config (conf : in out wifi_ap_config_t);
   --  Set the configuration of the soft-AP.
   --
   --  Note: This API can be called only when soft-AP interface is enabled,
   --  otherwise, API fail.
   --
   --  Note: ESP devices are limited to only one channel, so when in the
   --  soft-AP+station mode, the soft-AP will adjust its channel
   --  automatically to be the same as the channel of the station.
   --
   --  Note: The configuration will be stored in NVS.
   --
   --  `iface` parameter is implicit in the specialized procedures
   --  @param conf soft-AP configuration
   --  @raise ESPIDF_Error raised on error:
   --    - `ESP_ERR_WIFI_NOT_INIT` if WiFi is not initialized by
   --      `esp_wifi_init`
   --    - `ESP_ERR_INVALID_ARG` if argument is invalid
   --    - `ESP_ERR_WIFI_IF` if interface is invalid
   --    - `ESP_ERR_WIFI_MODE` if mode is invalid
   --    - `ESP_ERR_WIFI_PASSWORD` if password is invalid
   --    - `ESP_ERR_WIFI_NVS` if WiFi internal NVS error occurs
   --    - `ESP_ERR_WIFI_STATE` if WiFi is still connecting when
   --      `esp_wifi_set_config` is invoked
   --    - other error codes, see `esp_err.h`
   procedure esp_wifi_set_config (conf : in out wifi_sta_config_t);
   --  Set the configuration of the station.
   --
   --  Note: This API can be called only when station interface is enabled,
   --  otherwise, API fail.
   --
   --  Note: ESP devices are limited to only one channel, so when in the
   --  soft-AP+station mode, the soft-AP will adjust its channel
   --  automatically to be the same as the channel of the station.
   --
   --  Note: The configuration will be stored in NVS.
   --
   --  `iface` parameter is implicit in the specialized procedures
   --  @param conf station configuration
   --  @raise ESPIDF_Error raised on error:
   --    - `ESP_ERR_WIFI_NOT_INIT` if WiFi is not initialized by
   --      `esp_wifi_init`
   --    - `ESP_ERR_INVALID_ARG` if argument is invalid
   --    - `ESP_ERR_WIFI_IF` if interface is invalid
   --    - `ESP_ERR_WIFI_MODE` if mode is invalid
   --    - `ESP_ERR_WIFI_PASSWORD` if password is invalid
   --    - `ESP_ERR_WIFI_NVS` if WiFi internal NVS error occurs
   --    - `ESP_ERR_WIFI_STATE` if WiFi is still connecting when
   --      `esp_wifi_set_config` is invoked
   --    - other error codes, see `esp_err.h`

   function esp_wifi_set_storage (storage : wifi_storage_t) return esp_err_t
     with Import, Convention => C, External_Name => "esp_wifi_set_storage";
   --  Set the WiFi API configuration storage type.
   --
   --  Note: The default value is `WIFI_STORAGE_FLASH`.
   --  @param storage storage type
   --  @return
   --    - `ESP_OK` if storage type was set successfully
   --    - `ESP_ERR_WIFI_NOT_INIT` if WiFi is not initialized by
   --      `esp_wifi_init`
   --    - `ESP_ERR_INVALID_ARG` if argument is invalid

   procedure esp_wifi_set_storage (storage : wifi_storage_t);
   --  Set the WiFi API configuration storage type.
   --
   --  Note: The default value is `WIFI_STORAGE_FLASH`.
   --  @param storage storage type
   --  @raise ESPIDF_Error raised on error:
   --    - `ESP_ERR_WIFI_NOT_INIT` if WiFi is not initialized by
   --      `esp_wifi_init`
   --    - `ESP_ERR_INVALID_ARG` if argument is invalid

   function esp_wifi_restore return esp_err_t
     with Import, Convention => C, External_Name => "esp_wifi_restore";
   --  Restore WiFi stack persistent settings to default values.
   --
   --  This function will reset settings made using the following APIs:
   --    - `esp_wifi_set_bandwidth`,
   --    - `esp_wifi_set_protocol`,
   --    - `esp_wifi_set_config` related
   --    - `esp_wifi_set_mode`
   --  @return
   --    - `ESP_OK` if settings were restored successfully
   --    - `ESP_ERR_WIFI_NOT_INIT` if WiFi is not initialized by
   --      `esp_wifi_init`

   procedure esp_wifi_restore;
   --  Restore WiFi stack persistent settings to default values.
   --
   --  This function will reset settings made using the following APIs:
   --    - `esp_wifi_set_bandwidth`,
   --    - `esp_wifi_set_protocol`,
   --    - `esp_wifi_set_config` related
   --    - `esp_wifi_set_mode`
   --  @raise ESPIDF_Error raised on error:
   --    - `ESP_ERR_WIFI_NOT_INIT` if WiFi is not initialized by
   --      `esp_wifi_init`

   function esp_wifi_start return esp_err_t
     with Import, Convention => C, External_Name => "esp_wifi_start";
   --  Start WiFi according to current configuration.
   --
   --  If mode is `WIFI_MODE_STA`, it creates station control block and
   --  starts station. If mode is `WIFI_MODE_AP`, it creates soft-AP control
   --  block and starts soft-AP. If mode is `WIFI_MODE_APSTA`, it creates
   --  soft-AP and station control block and starts soft-AP and station. If
   --  mode is `WIFI_MODE_NAN`, it creates NAN control block and starts NAN.
   --  @return
   --    - `ESP_OK` if WiFi was started successfully
   --    - `ESP_ERR_WIFI_NOT_INIT` if WiFi is not initialized by
   --      `esp_wifi_init`
   --    - `ESP_ERR_INVALID_ARG` if the function called inside the API was
   --      passed invalid argument (it doesn't normally happen); user should
   --      check if the WiFi related config is correct
   --    - `ESP_ERR_NO_MEM` if out of memory
   --    - `ESP_ERR_WIFI_CONN` if WiFi internal error occurs, station or
   --      soft-AP control block is wrong
   --    - `ESP_FAIL` if other WiFi internal error occurs

   procedure esp_wifi_start;
   --  Start WiFi according to current configuration.
   --
   --  If mode is `WIFI_MODE_STA`, it creates station control block and
   --  starts station. If mode is `WIFI_MODE_AP`, it creates soft-AP control
   --  block and starts soft-AP. If mode is `WIFI_MODE_APSTA`, it creates
   --  soft-AP and station control block and starts soft-AP and station. If
   --  mode is `WIFI_MODE_NAN`, it creates NAN control block and starts NAN.
   --  @raise ESPIDF_Error raised on error:
   --    - `ESP_ERR_WIFI_NOT_INIT` if WiFi is not initialized by
   --      `esp_wifi_init`
   --    - `ESP_ERR_INVALID_ARG` if the function called inside the API was
   --      passed invalid argument (it doesn't normally happen); user should
   --      check if the WiFi related config is correct
   --    - `ESP_ERR_NO_MEM` if out of memory
   --    - `ESP_ERR_WIFI_CONN` if WiFi internal error occurs, station or
   --      soft-AP control block is wrong
   --    - `ESP_FAIL` if other WiFi internal error occurs

   function esp_wifi_stop return esp_err_t
     with Import, Convention => C, External_Name => "esp_wifi_stop";
   --  Stop WiFi.
   --
   --  If mode is `WIFI_MODE_STA`, it stops station and frees station control
   --  block. If mode is `WIFI_MODE_AP`, it stops soft-AP and frees soft-AP
   --  control block. If mode is `WIFI_MODE_APSTA`, it stops station/soft-AP
   --  and frees station/soft-AP control block. If mode is `WIFI_MODE_NAN`,
   --  it stops NAN and frees NAN control block.
   --  @return
   --    - `ESP_OK` if WiFi was stopped successfully
   --    - `ESP_ERR_WIFI_NOT_INIT` if WiFi is not initialized by
   --      `esp_wifi_init`

   procedure esp_wifi_stop;
   --  Stop WiFi.
   --
   --  If mode is `WIFI_MODE_STA`, it stops station and frees station control
   --  block. If mode is `WIFI_MODE_AP`, it stops soft-AP and frees soft-AP
   --  control block. If mode is `WIFI_MODE_APSTA`, it stops station/soft-AP
   --  and frees station/soft-AP control block. If mode is `WIFI_MODE_NAN`,
   --  it stops NAN and frees NAN control block.
   --  @raise ESPIDF_Error raised on error:
   --    - `ESP_ERR_WIFI_NOT_INIT` if WiFi is not initialized by
   --      `esp_wifi_init`

   function esp_wifi_connect return esp_err_t
     with Import, Convention => C, External_Name => "esp_wifi_connect";
   --  Connect WiFi station to the AP.
   --
   --  Note: This API only impact `WIFI_MODE_STA` or `WIFI_MODE_APSTA` mode.
   --
   --  Note: If station interface is connected to an AP, call
   --  `esp_wifi_disconnect` to disconnect.
   --
   --  Note: The scanning triggered by `esp_wifi_scan_start` will not be
   --  effective until connection between device and the AP is established.
   --  If device is scanning and connecting at the same time, it will abort
   --  scanning and return a warning message and error number
   --  `ESP_ERR_WIFI_STATE`.
   --
   --  Note: This API attempts to connect to an Access Point (AP) only once.
   --  To enable reconnection in case of a connection failure, please use the
   --  'failure_retry_cnt' feature in the `wifi_sta_config_t`. Users are
   --  suggested to implement reconnection logic in their application for
   --  scenarios where the specified AP does not exist, or reconnection is
   --  desired after the device has received a disconnect event.
   --  @return
   --    - `ESP_OK` if connection to the AP was initiated successfully
   --    - `ESP_ERR_WIFI_NOT_INIT` if WiFi is not initialized by
   --      `esp_wifi_init`
   --    - `ESP_ERR_WIFI_NOT_STARTED` if WiFi is not started by
   --      `esp_wifi_start`
   --    - `ESP_ERR_WIFI_MODE` if WiFi mode error occurs
   --    - `ESP_ERR_WIFI_CONN` if WiFi internal error occurs, station or
   --      soft-AP control block is wrong
   --    - `ESP_ERR_WIFI_SSID` if SSID of AP which station connects is invalid

   procedure esp_wifi_connect;
   --  Connect WiFi station to the AP.
   --
   --  Note: This API only impact `WIFI_MODE_STA` or `WIFI_MODE_APSTA` mode.
   --
   --  Note: If station interface is connected to an AP, call
   --  `esp_wifi_disconnect` to disconnect.
   --
   --  Note: The scanning triggered by `esp_wifi_scan_start` will not be
   --  effective until connection between device and the AP is established.
   --  If device is scanning and connecting at the same time, it will abort
   --  scanning and return a warning message and error number
   --  `ESP_ERR_WIFI_STATE`.
   --
   --  Note: This API attempts to connect to an Access Point (AP) only once.
   --  To enable reconnection in case of a connection failure, please use the
   --  'failure_retry_cnt' feature in the `wifi_sta_config_t`. Users are
   --  suggested to implement reconnection logic in their application for
   --  scenarios where the specified AP does not exist, or reconnection is
   --  desired after the device has received a disconnect event.
   --  @raise ESPIDF_Error raised on error:
   --    - `ESP_ERR_WIFI_NOT_INIT` if WiFi is not initialized by
   --      `esp_wifi_init`
   --    - `ESP_ERR_WIFI_NOT_STARTED` if WiFi is not started by
   --      `esp_wifi_start`
   --    - `ESP_ERR_WIFI_MODE` if WiFi mode error occurs
   --    - `ESP_ERR_WIFI_CONN` if WiFi internal error occurs, station or
   --      soft-AP control block is wrong
   --    - `ESP_ERR_WIFI_SSID` if SSID of AP which station connects is invalid

   function esp_wifi_disconnect return esp_err_t
     with Import, Convention => C, External_Name => "esp_wifi_disconnect";
   --  Disconnect WiFi station from the AP.
   --  @return
   --    - `ESP_OK` if station was disconnected successfully
   --    - `ESP_ERR_WIFI_NOT_INIT` if WiFi was not initialized by
   --      `esp_wifi_init`
   --    - `ESP_ERR_WIFI_NOT_STARTED` if WiFi was not started by
   --      `esp_wifi_start`
   --    - `ESP_FAIL` if other WiFi internal error occurs

   procedure esp_wifi_disconnect;
   --  Disconnect WiFi station from the AP.
   --  @raise ESPIDF_Error raised on error:
   --    - `ESP_ERR_WIFI_NOT_INIT` if WiFi was not initialized by
   --      `esp_wifi_init`
   --    - `ESP_ERR_WIFI_NOT_STARTED` if WiFi was not started by
   --      `esp_wifi_start`
   --    - `ESP_FAIL` if other WiFi internal error occurs

private

   sizeof_wifi_init_config_t : constant int
      with Import, Convention => C,
           Link_Name => "__ada_sizeof_wifi_init_config_t";

   type wifi_init_config_t_Storage is
     new System.Storage_Elements.Storage_Array
       (1 .. System.Storage_Elements.Storage_Count
               (sizeof_wifi_init_config_t)) with Convention => C;

   procedure Initialize (Self : in out wifi_init_config_t);

   type wifi_init_config_t is record
      Storage : wifi_init_config_t_Storage := (others => 0);
   end record
     with Convention => C,
          Finalizable =>
            (Initialize           => Initialize,
             Relaxed_Finalization => True);

   sizeof_wifi_config_t : constant int
      with Import, Convention => C,
           Link_Name => "__ada_sizeof_wifi_config_t";

   type wifi_ap_config_t is
     new System.Storage_Elements.Storage_Array
       (1 .. System.Storage_Elements.Storage_Count (sizeof_wifi_config_t))
       with Convention => C, Default_Component_Value => 0;

   type wifi_sta_config_t is
     new System.Storage_Elements.Storage_Array
       (1 .. System.Storage_Elements.Storage_Count (sizeof_wifi_config_t))
       with Convention => C, Default_Component_Value => 0;

end ESPIDF.WiFi;
