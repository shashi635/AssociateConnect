using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Cog.MLIAD.BusinessLogic.Associate
{
   public class Category
    {
        #region ctor
        public Category()
        {

        }
        #endregion


        #region public members
            public string CategoryDesc { get; set; }
            public int CategoryID{get; set;}
            public int? IsActive	{get; set; }
            public string id { get; set; }
            public string oper { get; set; }
        #endregion
    }
}
