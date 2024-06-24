using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Mvc;
using Buscar_Aula.Models;

namespace Buscar_Aula.Controllers
{
    public class AulaController : Controller
    {
        public ActionResult AulaBuscar(int? codAula)
        {
            IEnumerable<Aula> aulas = new List<Aula>();

            if (codAula.HasValue)
            {
                aulas = BuscarAula(codAula.Value);

                if (!aulas.Any())
                {
                    ViewBag.ErrorMessage = "No se encontraron aulas que coincidan con los criterios de búsqueda.";
                }
            }

            return View(aulas);
        }

        IEnumerable<Aula> BuscarAula(int codAula)
        {
            var aulas = new List<Aula>();

            using (SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings["cadena"].ConnectionString))
            {
                cn.Open();

                using (SqlCommand cmd = new SqlCommand("BuscarAula", cn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add(new SqlParameter("@Cod_Aula", codAula));

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            var aula = new Aula
                            {
                                cod_aula = dr.GetInt32(dr.GetOrdinal("cod_aula")),
                                tipo_aula = dr.GetString(dr.GetOrdinal("tipo_aula")),
                                hora_inicio = dr.GetTimeSpan(dr.GetOrdinal("hora_inicio")),
                                hora_fin = dr.GetTimeSpan(dr.GetOrdinal("hora_fin")),
                                estado = dr.GetString(dr.GetOrdinal("estado"))
                            };
                            aulas.Add(aula);
                        }
                    }
                }
            }

            return aulas;
        }
    }
}