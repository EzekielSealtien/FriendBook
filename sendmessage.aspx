using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TP_part1
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack == false)
            {
                SqlConnection myCon = new SqlConnection();
                myCon.ConnectionString = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=ProjetDb;Integrated Security=True";
                myCon.Open();

                string sql = "SELECT Numero,Nom from Membres order by Nom";
                SqlCommand myCmd = new SqlCommand(sql, myCon);
                SqlDataReader myRder = myCmd.ExecuteReader();
                cboDestinataire.Items.Add(new ListItem("Choisir un destinataire", "0"));
                cboDestinataire.Items[0].Selected = true;
                while (myRder.Read())
                {
                    ListItem item = new ListItem();
                    item.Text = myRder["Nom"].ToString() + "(" + myRder["Numero"].ToString() + ")";
                    item.Value = myRder["Numero"].ToString();
                    cboDestinataire.Items.Add(item);
                }
                myRder.Close();
                myCon.Close();
            }
        }


        protected void btnEnvoyer_Click(object sender, EventArgs e)
        {
            int numEnvoyeur = Convert.ToInt32(Session["Numero"]);
            int numReceveur = Convert.ToInt32(cboDestinataire.SelectedItem.Value);
            string titre = txtTitre.Text;
            string msg = txtMessage.Text;
            string dateAujourdhui = DateTime.Today.ToShortDateString();

            if (cboDestinataire.SelectedIndex == 0)
            {
                lblErreur.Text = "Erreur : Veuillez choisir un destinataire svp.";
                return;
            }
            if (titre.Length == 0)
            {
                lblErreur.Text = "Erreur : Veuillez saisir un titre pour le message svp.";
                return;
            }
            SqlConnection myCon = new SqlConnection();
            myCon.ConnectionString = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=ProjetDb;Integrated Security=True";
            myCon.Open();

            string sql = "insert into Messages (Titre,Message,Date,Envoyeur,Receveur,Nouveau) values ('" + titre + "','" + msg + "','" + dateAujourdhui + "','" + numEnvoyeur + "','" + numReceveur + "','True')";
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