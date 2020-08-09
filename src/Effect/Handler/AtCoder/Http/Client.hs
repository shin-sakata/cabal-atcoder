module Effect.Handler.AtCoder.Http.Client
  ( reqWithSession,
    runSession,
    HttpClient,
    GET (GET),
    NoReqBody (NoReqBody),
    Option,
    POST (POST),
    ReqBodyUrlEnc (..),
    Scheme (Https),
    Url,
    bsResponse,
    https,
    (/:),
    (=:),
    responseBody,
  )
where

import Data.Extensible (type (>:))
import Data.Extensible.Effect (Eff, leaveEff, peelEff0, retractEff)
import Data.Extensible.Effect.Default
import Essential hiding (lift)
import Effect.Adapter.SessionRepository (Session)
import Network.HTTP.Req
  ( GET (GET),
    NoReqBody (NoReqBody),
    Option,
    POST (POST),
    ReqBodyUrlEnc (..),
    Scheme (Https),
    Url,
    bsResponse,
    https,
    responseBody,
    (/:),
    (=:),
  )
import qualified Network.HTTP.Req as Req
import RIO.State (get, put)
import qualified RIO.Text as T

type HttpClient = Eff '[StateDef Session, "IO" >: IO]

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
  HttpClient response
reqWithSession method url body responseType option = do
  cookie <- get

  r <-
    liftIO $
      Req.runReq Req.defaultHttpConfig $
        Req.req
          method
          url
          body
          responseType
          (option <> Req.cookieJar cookie)

  put (Req.responseCookieJar r)
  return r
