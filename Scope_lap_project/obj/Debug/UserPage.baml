   M S B A M L   `   `   `  ����B  >WpfApp1, Version=0.0.0.1, Culture=neutral, PublicKeyToken=null!clr-namespace:WpfApp1WpfApp1  5   	       WpfApp1.UserPage   5   	   R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35\ XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35D 9http://schemas.microsoft.com/winfx/2006/xaml/presentation    R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5   	   @d2http://schemas.microsoft.com/expression/blend/2008     5   	   Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     5   	   'localclr-namespace:WpfApp1     5   	   8
syncfusion!http://schemas.syncfusion.com/wpf     5   	   -   5          � Title$  Scope Lap: user page��5	   	   $	��450��6&   $	��800��63    � 
ResizeMode$ NoResize=�6Z    � WindowStartupLocation$ CenterOwner=�6p   .��5
      �  � ColumnDefinitions 5   
   �� 5      $��1* �6   �� 5      $��1* �6   �� 5      $��1* �6   �� 5      $��1* �6    � RowDefinitions 5   
   �� 5      $��1* �6   �� 5      $��1* �6   �� 5      $��1* �6   �� 5      $��1* �6   �� 5      $��1* �6   �� 5      $��6* �6   .+�5   
   �� $��0��6   $��0��6   $��2��6-   $(��"Greetings on Nurnburgring! Driver:��5      $
��Left=�6;   $��Center=�6V   $��30��6q   $	��250��6}   $��14(�6�   $
��Bold"�6�   �� 5   
   -   5         ��Name$ 
UserHeader��5      $��0��5      $��1��6   $��Right=�5   !   $��30��6=   $	��137��6I   $��16(�6U   $
��Bold"�6c   ���	#FF1B7D60$	��Top=�6�   �� 5   
   $��4��6   $��0��6   $!��Your latest track sessions:��5       $��Bottom=�63   $��Center=�6N   $��13(�6r   &   System.Windows.Controls.DataGrid  5"   
   -   5          Name$ Table��5#      $��4��5"      $��0��6    $��4��60      AutoGenerateColumns .  $��Center=�5#   8   $	��Top=�6U   $	��780��6m      
IsReadOnly . 	   SelectionMode$	 Single=�5$      
   SelectionUnit$
 FullRow=�66      AlternatingRowBackground �	#FFD8C4AC   RowBackground �	#FFB6E0D7$��0,43,0,0q�5%   L   $��2��6^    �� SelectedValuePath$ [Session N]��5&   F   $��Bahnschrift Light)�5'      $��13(�62   $��Regular"�6@    �� SelectedValue 5&      �� *[Session N]+ �� Mode$ OneWay=�   Columns 5(      0  *System.Windows.Controls.DataGridTextColumn  5)      ,  &System.Windows.Controls.DataGridColumn   Header$
 Time��6E      
Visibility$ Hidden=�6S   1  +System.Windows.Controls.DataGridBoundColumn   Binding 6%   �� *[Session N]+6S     5*      $ Track length��6H      CanUserSort .   6%   �� *[Track length]+6^     5+      $
 Time��6>      Width5  /System.Windows.Controls.DataGridLengthConverter$ 73 6L      CanUserResize .   6%   �� *Time+6W     5,      $	 Car��6=   $	 300 6J    6%   �� *Car+6J     5-      $ Driver��6@    6%   �� *Driver+6@     5.      $
 Date��6f    6%   �� *Date+ �� StringFormat$ d�� �� ConverterCulture$ de-DE��6f   50      �� 51   
   -   5         ��Name$ newBtn��51      $��0��6!   $��1��61   $��New session��6>   $��30��6i   $	��190��6u   �� 52   
   -   5        $ editBtn��52      $��0��6"   $��2��62   $��Edit session��6?   $��30��6l   $	��190��6x   �� 53   
   -   5        $ delDtn��53      $��0��6!   $��3��61   $��Delete session��6>   $��30��6l   $	��190��6x   �� 55   
   -   5        $ yourBtn��55      $��2��6"   $��1��62   $��Your sessions��6?   $��30��6m   $	��190��6y   �� 56   
   -   5        $ top100��56      $��2��6!   $��3��61   $��View top 100��6>   $��30��6j   $	��190��6v   �� 57   
   -	   5        $ alsess��57      $��3��6!   $��1��61   $ ��All drivers track sessions��6>   $��30��6c   $	��190��6o   6{   5:      5;      