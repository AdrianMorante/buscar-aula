using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Buscar_Aula.Models
{
    public class Aula
    {
        public int cod_aula { get; set; }
        public string tipo_aula { get; set; }
        public TimeSpan hora_inicio { get; set; }
        public TimeSpan hora_fin { get; set; }
        public string estado { get; set; }
    }
}