using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TP_part1
{
    public partial class sendMessageIndividuel : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnEnvoyer_Click(object sender, EventArgs e)
        {
            int numEnvoyeur = Convert.ToInt32(Session["Numero"]);
            int numReceveur = Convert.ToInt32(Request.QueryString["refMsg"].ToString());
            string titre = txtTitre.Text;
            string msg = txtMessage.Text;
            string dateAujourdhui = DateTime.Today.ToShortDateString();


            if (titre.Length == 0)
            {
                lblErreur.Text = "Erreur : Veuillez saisir un titre pour le message svp.";
                return;
            }
            SqlConnection myCon = new SqlConnection();
            myCon.ConnectionString = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=ProjetDb;Integrated Security=True";
            myCon.Open();

            string sql = "insert into Messages (Titre,Message,Date,Envoyeur,Receveur,Nouveau) values ('" + titre.Replace("'", "''") + "','" + msg.Replace("'", "''") + "','" + dateAujourdhui + "','" + numEnvoyeur + "','" + numReceveur + "','True')";
            SqlCommand myCmd = new SqlCommand(sql, myCon);
            myCmd.ExecuteNonQuery();
            myCon.Close();
            Response.Redirect("Accueil.aspx");

        }

        protected void btnEffacer_Click(object sender, EventArgs e)
        {
            txtTitre.Text = "";
            txtMessage.Text = "";
        }

        protected void btnAnnuler_Click(object sender, EventArgs e)
        {
            Response.Redirect("Accueil.aspx");
        }
    }
}