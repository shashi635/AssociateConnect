using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Cog.MLIAD.BusinessLogic.Associate
{
    public class SoftwareResource
    {
        #region ctor
        public SoftwareResource() { }
        #endregion
        #region public members
        public int? SoftwareResourceID { get; set; }
        public string SoftwareResourceDesc { get; set; }
        #endregion
    }

}
