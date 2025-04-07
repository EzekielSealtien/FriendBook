using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TP_part1
{
    public partial class rechercher : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                SqlConnection conn = new SqlConnection();
                conn.ConnectionString = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=ProjetDb;Integrated Security=True";
                conn.Open();
                string sql = "SELECT DISTINCT Diplome, Groupe, Raison FROM Membres";
                SqlCommand cmd = new SqlCommand(sql, conn);
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    ListItem listItemEthnie = new ListItem();
                    listItemEthnie.Text = reader["Groupe"].ToString();
                    listItemEthnie.Value = reader["Groupe"].ToString();

                    ListItem listItemRaison = new ListItem();
                    listItemRaison.Text = reader["Raison"].ToString();
                    listItemRaison.Value = reader["Raison"].ToString();


                    ListItem listItemDiplome = new ListItem();
                    listItemDiplome.Text = reader["Diplome"].ToString();
                    listItemDiplome.Value = reader["Diplome"].ToString();

                    cboEthnie.Items.Add(listItemEthnie);
                    cboRaison.Items.Add(listItemRaison);
                    cboDiplome.Items.Add(listItemDiplome);

                }
                reader.Close();
                conn.Close();

            }


        }

        protected void btnRechercher_Click(object sender, EventArgs e)
        {
            string diplome=cboDiplome.SelectedItem.Text;
            string genre = rdBtnGenre.SelectedItem.Value;
            string ethnie = cboEthnie.SelectedItem.Text;
            string raison = cboRaison.SelectedItem.Text;

            if (genre == "C") {
                lblErreur.Text = "Veuiller choisir le genre.";
                return;
            }
            SqlConnection conn = new SqlConnection();
            conn.ConnectionString = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=ProjetDb;Integrated Security=True";
            conn.Open();

            string sql = $"SELECT Numero, Nom, Prenom, Naissance,Diplome,Groupe,Raison FROM Membres WHERE Genre='{genre}' AND Diplome='{diplome}'  AND Groupe='{ethnie}'  AND Raison='{raison}' ";
            SqlCommand cmd = new SqlCommand(sql, conn);
            SqlDataReader reader = cmd.ExecuteReader();

            StringBuilder html = new StringBuilder();
            while (reader.Read())
            {
                int num= Convert.ToInt32(reader["Numero"].ToString());
                string nomMembre = reader["Nom"].ToString();
                string prenomMembre = reader["Prenom"].ToString();
                DateTime naissanceMembre = Convert.ToDateTime(reader["Naissance"]);
                int ageMembre = DateTime.Now.Year - naissanceMembre.Year;
                string diplomeMembre = reader["Diplome"].ToString();
                string ethnieMembre = reader["Groupe"].ToString();
                string raisonMembre = reader["Raison"].ToString();

                html.Append("<div class='profile'>");
                html.Append($"<img src='./images/profile.png' alt='Profile Image' width='100' height='100' />");
                html.Append($"<p>Nom: {nomMembre}</p>");
                html.Append($"<p>Prénom: {prenomMembre}</p>");
                html.Append($"<p>Âge: {ageMembre} ans</p>");
                html.Append($"<p>Diplome: {diplomeMembre} </p>");
                html.Append($"<p>Ethnie: {ethnieMembre} </p>");
                html.Append($"<p>Cherche : {raisonMembre} </p>");
                html.Append($"<a href='sendMessageIndividuel.aspx?refMsg={num}'>Ecrire</a>");

                html.Append("</div>");
            }

            reader.Close();
            conn.Close();

            profilesContainer.InnerHtml = html.ToString();
        }

    }
}