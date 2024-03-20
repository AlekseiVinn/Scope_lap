using Npgsql;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace WpfApp1
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private NpgsqlConnection npgsqlConnection;
        private UserPage userPage;

        public NpgsqlConnection NpgsqlConnection
        {
            get
            { return npgsqlConnection; }
        }

        public MainWindow()
        {
            InitializeComponent();
        }

        private void btn_Click(object sender, RoutedEventArgs e)
        {
            npgsqlConnection = new NpgsqlConnection(Pgstring.Create(loginBox.Text, passwordBox.Password));
            try
            {
                npgsqlConnection.Open();
                //MessageBox.Show($"All good {npgsqlConnection.State}", "Успешный вход", MessageBoxButton.OK);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                return;
            }

            User activeUser = new User(npgsqlConnection, loginBox.Text);
            userPage = new UserPage(activeUser);
            userPage.Owner = this;
            userPage.Show();
            this.Hide();

        }

        private void btnClose_Click(object sender, RoutedEventArgs e)
        {
            Close();
        }
    }
}
