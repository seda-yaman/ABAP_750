*&---------------------------------------------------------------------*
*& Report ZSY_002_P_NW_SYNTX
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsy_002_p_nw_syntx.

TYPES :BEGIN OF ty_first,
         werks  TYPE werks_d,
         arbpl  TYPE arbpl,
         toplam TYPE menge_d,
         meins  TYPE meins,
         islem  TYPE int8,
       END OF ty_first.

TYPES : tt_first TYPE TABLE OF ty_first WITH EMPTY KEY.

DATA(lt_first) = VALUE tt_first(
  ( werks = '2013' arbpl = '07' toplam = '16'   meins = '' )
  ( werks = '2013' arbpl = '07' toplam = '32'   meins = '' )
  ( werks = '2015' arbpl = '09' toplam = '07'   meins = '' ) ). "tabloya veriler atandı

DATA : lt_first2 TYPE tt_first.

lt_first2       = VALUE #( FOR GROUPS ls_group OF <ls_first> IN lt_first GROUP BY ( werks = <ls_first>-werks
                                                                                    arbpl = <ls_first>-arbpl ) "werks ve arbpl gruplandı
                ( VALUE #( arbpl  = ls_group-arbpl
                           werks  = ls_group-werks
                           toplam = REDUCE netwr( INIT val TYPE menge_d
                                                   FOR ls_first  IN GROUP ls_group
                                                   NEXT val = val + ls_first-toplam ) ) ) ) . "gruplananların REDUCE ile toplamı alındı

DATA(lt_first3) = VALUE tt_first( FOR ls_first IN lt_first2 LET lv_meins = 'ADT'              "ADT sabit yazdırıldı
                                                                lv_carp1 = 5                  "for içinde LET ile değişken oluşturuldu
                                                                lv_carp2 = 3 IN ( meins  = lv_meins
                                                                                    werks  = ls_first-werks
                                                                                    arbpl  = ls_first-arbpl
                                                                                    toplam = ls_first-toplam
                                                                                    islem  = lv_carp1 * lv_carp2  ) ). "çarpımı alındı işlem kolonuna atıldı
cl_demo_output=>display( lt_first3 ).
