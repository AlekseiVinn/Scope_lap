﻿#pragma checksum "..\..\OnEditWindow.xaml" "{8829d00f-11b8-4213-878b-770e8597ac16}" "E18FC3F9B62F92C55F96AE3F921DE1F374BD2A8A94F900E55502F4968956F188"
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.42000
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

using System;
using System.Diagnostics;
using System.Windows;
using System.Windows.Automation;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Markup;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Media.Effects;
using System.Windows.Media.Imaging;
using System.Windows.Media.Media3D;
using System.Windows.Media.TextFormatting;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Windows.Shell;
using WpfApp1;


namespace WpfApp1 {
    
    
    /// <summary>
    /// OnEditWindow
    /// </summary>
    public partial class OnEditWindow : System.Windows.Window, System.Windows.Markup.IComponentConnector {
        
        
        #line 10 "..\..\OnEditWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal WpfApp1.OnEditWindow edit_Session;
        
        #line default
        #line hidden
        
        
        #line 41 "..\..\OnEditWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Label DriverHeader;
        
        #line default
        #line hidden
        
        
        #line 48 "..\..\OnEditWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.ComboBox lapConf;
        
        #line default
        #line hidden
        
        
        #line 53 "..\..\OnEditWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TextBox lapMin;
        
        #line default
        #line hidden
        
        
        #line 55 "..\..\OnEditWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TextBox lapSec;
        
        #line default
        #line hidden
        
        
        #line 58 "..\..\OnEditWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TextBox lapMillisec;
        
        #line default
        #line hidden
        
        
        #line 65 "..\..\OnEditWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.ComboBox carList;
        
        #line default
        #line hidden
        
        
        #line 67 "..\..\OnEditWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.DatePicker datePick;
        
        #line default
        #line hidden
        
        
        #line 71 "..\..\OnEditWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Button okBtn;
        
        #line default
        #line hidden
        
        
        #line 74 "..\..\OnEditWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.Button cancelBtn;
        
        #line default
        #line hidden
        
        
        #line 81 "..\..\OnEditWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.TextBox noteToSave;
        
        #line default
        #line hidden
        
        
        #line 84 "..\..\OnEditWindow.xaml"
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields")]
        internal System.Windows.Controls.DataGrid Table;
        
        #line default
        #line hidden
        
        private bool _contentLoaded;
        
        /// <summary>
        /// InitializeComponent
        /// </summary>
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [System.CodeDom.Compiler.GeneratedCodeAttribute("PresentationBuildTasks", "4.0.0.0")]
        public void InitializeComponent() {
            if (_contentLoaded) {
                return;
            }
            _contentLoaded = true;
            System.Uri resourceLocater = new System.Uri("/WpfApp1;component/oneditwindow.xaml", System.UriKind.Relative);
            
            #line 1 "..\..\OnEditWindow.xaml"
            System.Windows.Application.LoadComponent(this, resourceLocater);
            
            #line default
            #line hidden
        }
        
        [System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [System.CodeDom.Compiler.GeneratedCodeAttribute("PresentationBuildTasks", "4.0.0.0")]
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Never)]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Design", "CA1033:InterfaceMethodsShouldBeCallableByChildTypes")]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Maintainability", "CA1502:AvoidExcessiveComplexity")]
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1800:DoNotCastUnnecessarily")]
        void System.Windows.Markup.IComponentConnector.Connect(int connectionId, object target) {
            switch (connectionId)
            {
            case 1:
            this.edit_Session = ((WpfApp1.OnEditWindow)(target));
            return;
            case 2:
            this.DriverHeader = ((System.Windows.Controls.Label)(target));
            return;
            case 3:
            this.lapConf = ((System.Windows.Controls.ComboBox)(target));
            return;
            case 4:
            this.lapMin = ((System.Windows.Controls.TextBox)(target));
            
            #line 53 "..\..\OnEditWindow.xaml"
            this.lapMin.PreviewTextInput += new System.Windows.Input.TextCompositionEventHandler(this.lapTime_PreviewTextInput);
            
            #line default
            #line hidden
            return;
            case 5:
            this.lapSec = ((System.Windows.Controls.TextBox)(target));
            
            #line 55 "..\..\OnEditWindow.xaml"
            this.lapSec.PreviewTextInput += new System.Windows.Input.TextCompositionEventHandler(this.lapTime_PreviewTextInput);
            
            #line default
            #line hidden
            return;
            case 6:
            this.lapMillisec = ((System.Windows.Controls.TextBox)(target));
            
            #line 58 "..\..\OnEditWindow.xaml"
            this.lapMillisec.PreviewTextInput += new System.Windows.Input.TextCompositionEventHandler(this.lapTime_PreviewTextInput);
            
            #line default
            #line hidden
            return;
            case 7:
            this.carList = ((System.Windows.Controls.ComboBox)(target));
            return;
            case 8:
            this.datePick = ((System.Windows.Controls.DatePicker)(target));
            return;
            case 9:
            this.okBtn = ((System.Windows.Controls.Button)(target));
            
            #line 71 "..\..\OnEditWindow.xaml"
            this.okBtn.Click += new System.Windows.RoutedEventHandler(this.okBtn_Click);
            
            #line default
            #line hidden
            return;
            case 10:
            this.cancelBtn = ((System.Windows.Controls.Button)(target));
            
            #line 74 "..\..\OnEditWindow.xaml"
            this.cancelBtn.Click += new System.Windows.RoutedEventHandler(this.cancelBtn_Click);
            
            #line default
            #line hidden
            return;
            case 11:
            this.noteToSave = ((System.Windows.Controls.TextBox)(target));
            return;
            case 12:
            this.Table = ((System.Windows.Controls.DataGrid)(target));
            return;
            }
            this._contentLoaded = true;
        }
    }
}

