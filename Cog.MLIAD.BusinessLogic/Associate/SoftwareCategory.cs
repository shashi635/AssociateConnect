using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Cog.MLIAD.BusinessLogic.Associate
{
    public class SoftwareCategory
    {
        #region ctor
        public SoftwareCategory() { }
        #endregion
        #region public members
        public int? SoftwareCategoryID { get; set; }
        public string SoftwareCategoryDesc { get; set; }
        #endregion
    }

}
