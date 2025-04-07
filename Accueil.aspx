using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Reflection.Emit;
using System.Security.Cryptography;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TP_part1
{
    public partial class Accueil : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack == false)
            {
                //Recuperer le numero du membre connecté
                int numeroMbr = Convert.ToInt32(Session["Numero"]);
                lblMessage.Text = "Bienvenue " + Session["Nom"];
                //Creation de la premiere ligne du tableau
                TableRow maLigne = new TableRow();
                TableCell maCellule = new TableCell();
                maCellule.Text = "Titres";
                maLigne.Cells.Add(maCellule);

                maCellule = new TableCell();
                maCellule.Text = "Envoyeurs";
                maLigne.Cells.Add(maCellule);

                maCellule = new TableCell();
                maCellule.Text = "Action";
                maLigne.Cells.Add(maCellule);
                maLigne.BackColor = Color.Aquamarine;

                //Ajouter la ligne dans la collection des lignes de  la table
                tableMessages.Rows.Add(maLigne);


                //Se connecter à la Bd

                SqlConnection myCon = new SqlConnection();
                myCon.ConnectionString = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=ProjetDb;Integrated Security=True";
                myCon.Open();

                string sql = "SELECT Messages.RefMessage,Messages.Titre,Membres.Nom,Messages.Nouveau from Messages,Membres where Messages.Envoyeur=Membres.Numero ";
                sql += "and Messages.Receveur='" + numeroMbr + "'";
                SqlCommand myCmd = new SqlCommand(sql, myCon);
                SqlDataReader myRder = myCmd.ExecuteReader();
                int nbMsg = 0; //Compteur pour les nouveaux messages
                while (myRder.Read())
                {
                    maLigne = new TableRow();
                    maCellule = new TableCell();
                    maCellule.Text = myRder["Titre"].ToString();
                    maLigne.Cells.Add(maCellule);

                    maCellule = new TableCell();
                    maCellule.Text = myRder["Nom"].ToString();
                    maLigne.Cells.Add(maCellule);

                    

                    maCellule = new TableCell();
                    int msgID = Convert.ToInt32(myRder["RefMessage"].ToString());
                    maCellule.Text = "<a href='lireMessage.aspx?refMsg=" + msgID + "'>Lire</a>";
                    maCellule.Text += "&nbsp;&nbsp;&nbsp;<a href='deleteMessage.aspx?refMsg=" + msgID + "'>Effacer</a>";
                    maLigne.Cells.Add(maCellule);



                    if (myRder["Nouveau"].ToString() == "True")
                    {
                        maLigne.BackColor = Color.Yellow;
                    }

                    //Ajouter la ligne dans la collection des lignes de  la table
                    tableMessages.Rows.Add(maLigne);
                    nbMsg++;
                }
                myRder.Close();
                myCon.Close();
                lblMessage.Text = "<br/> Vous avez " + nbMsg + " message(s).";

            }

        }
        protected void btnComposer_Click(object sender, EventArgs e)
        {
            Response.Redirect("sendmessage.aspx");
        }

        protected void btnRechercher_Click(object sender, EventArgs e)
        {
            Response.Redirect("rechercher.aspx");

        }
    }
}