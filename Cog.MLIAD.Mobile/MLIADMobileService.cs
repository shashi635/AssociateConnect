using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ServiceModel.Web;

namespace Cog.MLIAD.Mobile.Services
{
   public class MLIADMobileService
    {
    protected static void SetNoCache()
    {
      OutgoingWebResponseContext response = WebOperationContext.Current.OutgoingResponse;
      response.Headers.Add("Cache-Control", "no-cache");
      response.Headers.Add("Pragma", "no-cache");
    }

    protected static void SetCache(TimeSpan span)
    {
      OutgoingWebResponseContext response = WebOperationContext.Current.OutgoingResponse;
      response.Headers.Add("Expires", DateTime.Now.Add(span).ToString());
    }

    protected static void SetCache(int expiration)
    {
      OutgoingWebResponseContext response = WebOperationContext.Current.OutgoingResponse;
      response.Headers.Add("Expires", DateTime.Now.AddMinutes(expiration).ToString());
    }
    }
}
