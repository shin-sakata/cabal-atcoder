module Effect.Handler.AtCoder.Http.Client
  ( reqWithSession,
    runSession,
    module Req,
  )
where

import Control.Monad.State (get, put)
import qualified Effect.Adapter.IO as IO
import Effect.Adapter.SessionRepository (Session)
import Essential
import qualified Network.HTTP.Client as L
import Network.HTTP.Req
  ( GET (GET),
    HttpException (..),
    NoReqBody (NoReqBody),
    Option,
    POST (POST),
    ReqBodyUrlEnc (..),
    Scheme (Https),
    Url,
    bsResponse,
    https,
    responseBody,
    responseStatusCode,
    (/:),
    (=:),
  )
import qualified Network.HTTP.Req as Req
import qualified Network.HTTP.Types as T
import Network.HTTP.Types.Status (status404)

runSession :: s -> Eff (StateDef s : xs) a -> Eff xs a
runSession session = flip evalStateDef session

reqWithSession ::
  ( Req.HttpMethod method,
    Req.HttpBody body,
    Req.HttpResponse response,
    Req.HttpBodyAllowed (Req.AllowsBody method) (Req.ProvidesBody body)
  ) =>
  method ->
  Url scheme ->
  body ->
  Proxy response ->
  Option scheme ->
  Eff '[StateDef Session, IO.NamedEff] response
reqWithSession method url body responseType option = do
  cookie <- get

  r <-
    ( Req.runReq Req.defaultHttpConfig {Req.httpConfigCheckResponse = httpConfigCheckResponse} $
        Req.req
          method
          url
          body
          responseType
          (option <> Req.cookieJar cookie)
      )

  put (Req.responseCookieJar r)
  return r

-- 404は例外を飛ばさないように変更
httpConfigCheckResponse = \_ response preview ->
  let scode = T.statusCode $ L.responseStatus response
   in if (200 <= scode && scode < 300) || scode == 404
        then Nothing
        else Just (L.StatusCodeException (void response) preview)
