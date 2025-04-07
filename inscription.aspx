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
    public partial class inscription : System.Web.UI.Page
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

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            // Récupération des infos saisies par l'utilisateur
            string name = txtName.Text;
            string surname = txtSurname.Text;
            string genre = cboGenre.SelectedValue;
            string birthday = txtBirthday.Text;
            string diplome=txtDiplome.Text; 
            string groupEthnic = txtGroupeEthnique.Text;
            string raison = txtRaison.Text;
            string email = txtEmail.Text;
            string mdp1 = HashPassword(txtMdp1.Text);

            // Récupérer l'année de la date de naissance saisie
            int yearBirthday = Convert.ToDateTime(birthday).Year;

            // Chaîne de connexion
            string connectionString = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=ProjetDb;Integrated Security=True";

            SqlConnection myCon = new SqlConnection(connectionString);
            myCon.Open();

            // Vérifier si l'utilisateur existe déjà
            string sql = $"SELECT Email, Nom FROM Membres WHERE Email = '{email}' AND Nom = '{name}'";
            SqlCommand myCmd = new SqlCommand(sql, myCon);

            SqlDataReader myRder = myCmd.ExecuteReader();

            if (myRder.Read())
            {
                lblErreur.Text = "Cet utilisateur existe déjà; Veuillez en créer un autre!";
                myRder.Close();
                myCon.Close();
            }
            else
            {
                myRder.Close();
                sql = $"INSERT INTO Membres (Nom, Prenom, Genre, Diplome,Naissance, Groupe, Raison, Email, Mdp) VALUES ('{name}', '{surname}', '{genre}','{diplome}', '{birthday}', '{groupEthnic}', '{raison}', '{email}', '{mdp1}')";
                SqlCommand myCmd2 = new SqlCommand(sql, myCon);
                myCmd2.ExecuteNonQuery();
                myCon.Close();
                Response.Redirect("index.aspx");
            }
        }

    }
}