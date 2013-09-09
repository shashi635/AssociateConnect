using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Cog.MLIAD.BusinessLogic.Associate
{
    public class Account
    {
        #region ctor
        public Account() { }
        #endregion
        #region public members
        public int AccountID { get; set; }
        public string AccountName { get; set; }
        public int? PracticeID { get; set; }
        public bool IsActive { get; set; }
        #endregion
    }

}
