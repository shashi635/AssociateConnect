﻿using System;
using System.IO;
using System.IO.Compression;
using System.Net;
using System.Text;
using System.Web;
using System.Configuration;

namespace Cog.MLIAD.Util.HttpHandler
{
    public class HttpCombinerHandler : IHttpHandler
    {
        private const bool DO_GZIP = true;
		private readonly static TimeSpan CACHE_DURATION = TimeSpan.FromDays(90);

		public void ProcessRequest(System.Web.HttpContext context)
		{
			HttpRequest request = context.Request;

			// Read setName, contentType and version. All are required. They are
			// used as cache key
			string setName = request["s"] ?? string.Empty;
			string contentType = request["t"] ?? string.Empty;
			string version = request["v"] ?? string.Empty;

			// Decide if browser supports compressed response
			bool isCompressed = DO_GZIP && this.CanGZip(context.Request);

			// Response is written as UTF8 encoding. If you are using languages like
			// Arabic, you should change this to proper encoding 
			UTF8Encoding encoding = new UTF8Encoding(false);

			// If the set has already been cached, write the response directly from
			// cache. Otherwise generate the response and cache it
			if (!this.WriteFromCache(context, setName, version, isCompressed, contentType))
			{
				using (MemoryStream memoryStream = new MemoryStream(5000))
				{
					// Decide regular stream or GZipStream based on whether the response
					// can be cached or not
					using (Stream writer = isCompressed ?
							(Stream)(new GZipStream(memoryStream, CompressionMode.Compress)) :
							memoryStream)
					{

						// Load the files defined in <appSettings> and process each file
						string setDefinition =
								System.Configuration.ConfigurationManager.AppSettings[setName] ?? "";
						string[] fileNames = setDefinition.Split(new char[] { ',' },
								StringSplitOptions.RemoveEmptyEntries);

						foreach (string fileName in fileNames)
						{
							byte[] fileBytes = this.GetFileBytes(context, fileName.Trim(), encoding);
							writer.Write(fileBytes, 0, fileBytes.Length);
						}

						writer.Close();
					}

					// Cache the combined response so that it can be directly written
					// in subsequent calls 
					byte[] responseBytes = memoryStream.ToArray();
					context.Cache.Insert(GetCacheKey(setName, version, isCompressed),
							responseBytes, null, System.Web.Caching.Cache.NoAbsoluteExpiration,
							CACHE_DURATION);

					// Generate the response
					this.WriteBytes(responseBytes, context, isCompressed, contentType);
				}
			}
		}

		private byte[] GetFileBytes(System.Web.HttpContext context, string virtualPath, Encoding encoding)
		{
			if (virtualPath.StartsWith("http://", StringComparison.InvariantCultureIgnoreCase))
			{
				using (WebClient client = new WebClient())
				{
					return client.DownloadData(virtualPath);
				}
			}
			else
			{
				string physicalPath = context.Server.MapPath(virtualPath);
				byte[] bytes = File.ReadAllBytes(physicalPath);
				// TODO: Convert unicode files to specified encoding. For now, assuming
				// files are either ASCII or UTF8
				return bytes;
			}
		}

		private bool WriteFromCache(System.Web.HttpContext context, string setName, string version,
				bool isCompressed, string contentType)
		{
#if DEBUG
			return false;
#endif
			byte[] responseBytes = context.Cache[GetCacheKey(setName, version, isCompressed)] as byte[];

			if (null == responseBytes || 0 == responseBytes.Length) return false;

			this.WriteBytes(responseBytes, context, isCompressed, contentType);
			return true;
		}

		private void WriteBytes(byte[] bytes, System.Web.HttpContext context,
				bool isCompressed, string contentType)
		{
			HttpResponse response = context.Response;

			response.AppendHeader("Content-Length", bytes.Length.ToString());
			response.ContentType = contentType;
			if (isCompressed)
				response.AppendHeader("Content-Encoding", "gzip");

#if !DEBUG
			context.Response.Cache.SetCacheability(HttpCacheability.Private);
			context.Response.Cache.SetExpires(DateTime.Now.Add(CACHE_DURATION));
			context.Response.Cache.SetMaxAge(CACHE_DURATION);
#endif

			response.OutputStream.Write(bytes, 0, bytes.Length);
			try
			{
				response.Flush();
			}
			catch { }
		}

		private bool CanGZip(HttpRequest request)
		{
			string acceptEncoding = request.Headers["Accept-Encoding"];
			if (!string.IsNullOrEmpty(acceptEncoding) &&
					 (acceptEncoding.Contains("gzip") || acceptEncoding.Contains("deflate")))
				return true;
			return false;
		}

		private string GetCacheKey(string setName, string version, bool isCompressed)
		{
			return "HttpCombiner." + setName + "." + version + "." + isCompressed;
		}

		public bool IsReusable
		{
			get
			{
				return true;
			}
		}
    }
}
