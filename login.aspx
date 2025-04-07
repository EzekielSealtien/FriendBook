using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TP_part1
{
    public partial class accueil : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public static string HashPassword(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                StringBuilder builder = new StringBuilder();
                foreach (byte b in bytes)
                {
                    builder.Append(b.ToString("x2"));
                }
                return builder.ToString();
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string nom=txtName.Text;
            string mdp=HashPassword(txtMdp.Text);
            SqlConnection myCon = new SqlConnection();
            myCon.ConnectionString = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=ProjetDb;Integrated Security=True";
            myCon.Open();

            string sql = "SELECT Numero,Nom,Mdp,Prenom from Membres ";
            sql += "where Nom='" + nom + "'";
            SqlCommand myCmd = new SqlCommand(sql, myCon);
            SqlDataReader myRder = myCmd.ExecuteReader();
            if (myRder.Read() == true) //Si membre trouve
            {
                string storedHashedPassword = myRder["Mdp"].ToString();
                if (mdp.Equals(storedHashedPassword))
                {
                    Session["Numero"] = myRder["Numero"];
                    Session["Nom"] = myRder["Nom"];
                    Session["Prenom"] = myRder["Prenom"];
                    myRder.Close();
                    myCon.Close();
                    Response.Redirect("Accueil.aspx");

                }
                else
                {
                    myRder.Close();
                    myCon.Close();
                    lblErreur.Text = "Nom ou Mot de passe invalide,Ressayez à nouveau";

                }
            }
            else
            {
                myRder.Close();
                myCon.Close();
                lblErreur.Text = "Nom ou Mot de passe invalide,Ressayez à nouveau";

            }

        }
    }
}