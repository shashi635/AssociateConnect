using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Cog.MLIAD.BusinessLogic.Associate
{
    public class SoftwareVersion
    {
        #region ctor
        public SoftwareVersion() { }
        #endregion
        #region public members
        public int SoftwareVersionID { get; set; }
        public string SoftwareVersionDesc { get; set; }
        public int? SoftwareResourceID { get; set; }
        #endregion
    }

}
