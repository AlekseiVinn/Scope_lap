   M S B A M L   `   `   `  ����O  Kmscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e0891&clr-namespace:System;assembly=mscorlibSystem  5   	   B >WpfApp1, Version=0.0.0.1, Culture=neutral, PublicKeyToken=null!clr-namespace:WpfApp1WpfApp1 5   	      WpfApp1.OnEditWindow   5   	   0
syncfusion!http://schemas.syncfusion.com/wpf  R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35\ XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35D 9http://schemas.microsoft.com/winfx/2006/xaml/presentation    5   	   R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5   	   @d2http://schemas.microsoft.com/expression/blend/2008     5   	   Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     5   	   6sys&clr-namespace:System;assembly=mscorlib     5   	   'localclr-namespace:WpfApp1     5   	   -   5        $��edit_Session��5
   	     � Title$  Edit Session��5   	   $	��468��6   $	��757��6+    � WindowStartupLocation$ CenterOwner=�67    � 
ResizeMode$ NoResize=�6[   .��5      �  � ColumnDefinitions 5   
   �� 5      $��1* �6   �� 5      $��1* �6   �� 5      $��1* �6   �� 5      $
��0.5* �6   �� 5      $��1* �6   �� 5      $��1* �6   �� 5      $��1* �6    � RowDefinitions 5   
   �� 5      $��1* �6   �� 5      $��1* �6   �� 5      $��1* �6   �� 5      $��1* �6   �� 5      $��1* �6   �� 5      $��1* �6   �� 5      $��1* �6   �� 5      $��1* �6   �� 5      $��1* �6   �� 5       $��1* �6   �� 5!      $��1* �6   �� 5"      $��1* �6   �� 5#      $��1* �6   .+�5'   
   �� $��0��6   $��0��6   $��3��6-   $'��!Selected session info for driver:��6A   $��Center=�6m   $��Center=�6�   $��14(�5(      $
��Bold"�6   �� 5)   
   -   5         ��Name$ DriverHeader��5)      $��0��6&   $��3��63   $��2��6C   $��Center=�6W   $��Center=�6y   $��14(�5*      $
��Bold"�6   �� 5,   
   $��4��6   $��0��6   $��3��6-   $��Fill in session info:��6A   $��Center=�6a   $��Center=�6�   $��14(�5-      $
��Bold"�6   �� 5/   
   $��5��6   $��5��6   $��2��6-   $��Lap configuration:��6A   $��Bottom=�6^   $��Center=�6�   $
��Bold"�6�   �� 50   
   -   5         ��Name$ lapConf��50   t   $��6��6   $��5��6    $��2��60   $	��150��6D   $��30��6P   $	��Top=�6\   6t   �� 52   
   $��5��6   $��0��6   $��3��6-   $��Time:��6A   $��Bottom=�6Q   $��Center=�6s   $
��Bold"�6�   �� 53   
   -   5         ��Name$ lapMin��55      $��6��53      $��0��6   $��1��6/   $��28��6C   $��40��6O    �� TextAlignment$ Center=�6Z   $	��Top=�54      $��Right=�6*   	 �� 	MaxLength$	 3��55   N   $	��000��6\   $��Center=�6g   �� 56   
   -   5        $ lapSec��57      $��6��56      $��1��6   $��1��6/   $��28��6C   $��40��6O   $	��Top=�6Z   $ Center=�6r   $	 2��57   N   $��00��6\   $��Center=�6f   �� 58   
   -   5        $ lapMillisec��5:      $��6��58      $��2��6   $��2��6/   $��28��6C   $��40��6O   $ Center=�6Z   $	��Top=�59      $
��Left=�6*   $	 10��5:   S   $	��000��6b   $��Center=�6m   �� 5;   
   $��6��6   $��1��6   $��30��6-   $��20��69   $	��Top=�6D   $
��Left=�6\   $��:��6w   �� 5<   
   $��6��6   $��1��6   $��30��6-   $��20��69   $	��Top=�6D   $��Right=�6\   $�� .��6x   �� 5?   
   $��5��6   $��3��6   $��2��6-   $
��Car:��6A   $��Bottom=�6P   $��Center=�6r   $
��Bold"�6�   �� 5@   
   -   5        $ carList��5A      $��6��5@      $��3��6    $��2��60   $	��150��6D   $��30��6P   $	��Top=�6\   5A      �� 5B   
   $��7��6   $��0��6   $��2��6-   $��Date:��6A   $��Center=�6Q   $��Bottom=�6n   $
��Bold"�6�   (  "System.Windows.Controls.DatePicker  5C   
   -   5        
  Name$
 datePick��5C   �   $��8��6   $��0��6"   $��2��62   $��Center=�6F   $��27��6c   $	��Top=�6o   
 �� Now   DisplayDateEnd# Z 5D      �� 5F   
   -	   5         ��Name$ okBtn��5G      $��11��5F      $��4��6   $��2��6/   $	��150��6C   $��Right=�6O   $��Change session info��5G      $
��Bold"�6N   6b   �� 5I   
   -
   5        $ 	cancelBtn��5J      $��11��5I      $��1��6   $��2��6/   $
��Left=�6C   $	��100��6^   $��Cancel��5J       6K   �� 5K   
   $��8��6   $��2��6!   $��2��61   $O��ISession                              note                    (if needed):��5L      $��WrapWithOverflow=�5O      $��Center=�5P      $	��Top=�6.   $
��Bold"�6F   $��3��6X   $��80��6i   $��49��6t   �� 5Q   
   -   5        $ 
noteToSave��5Q   �   $��8��6   $��3��6   $��7��6/   $��3��6C   $��75��6T   $	��370��6`   $	��Top=�6l   6�   &   System.Windows.Controls.DataGrid  5S   
   -   5          Name$ Table��5T      $��1��5S      $��7��6    $��2��64      AutoGenerateColumns .  $��Center=�5T   >   $��Center=�6[   $	��720��6v   $��50��6�      
IsReadOnly .    SelectionMode$ Single=�5U   %      RowBackground �	#FFB6E0D7$��Bahnschrift Light)�5V      $��13(�63   $��Regular"�6A      Columns 5W      0  *System.Windows.Controls.DataGridTextColumn  5X      ,  &System.Windows.Controls.DataGridColumn   Header$ 	Session N��6E      Width5  /System.Windows.Controls.DataGridLengthConverter$ 70 6X      CanUserResize .  1  +System.Windows.Controls.DataGridBoundColumn   Binding 6%   �� *[Session N]+6c     5Y      $ Track length��6H      CanUserSort .   6%   �� *[Track length]+6^     5Z      $
 Time��6>   $ 75 6L    .   6%   �� *Time+6W     5[      $	 Car��6=   $	 200 6J    6%   �� *Car+6J     5\      $ Driver��6@      MinWidth$	 110Q�6P    6%   �� *Driver+6P     5]      $
 Date��6f    6%   �� *Date+ �� StringFormat$ d�� �� ConverterCulture$ de-DE��6f     5^      $
 Note��6H    6%   �� *[Session note]+6H   5`      5c      5d      