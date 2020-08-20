module Essential (module Expose, maybeToMonadThrow, eitherToMonadThrow) where

import Control.Arrow ((|||))
import Data.ByteString as Expose (ByteString)
import Data.Extensible as Expose hiding ((@=))
import Data.Extensible.Effect as Expose
import Data.Extensible.Effect.Default as Expose
import Data.String.Conversions as Expose (convertString)
import Data.Text as Expose (Text)
import RIO as Expose hiding (lift)
import System.FilePath as Expose (FilePath, (</>))
import Text.Shakespeare.Text as Expose (st)

maybeToMonadThrow :: (MonadThrow m, Exception e) => e -> Maybe a -> m a
maybeToMonadThrow e = throwM e `maybe` return

eitherToMonadThrow :: (MonadThrow m, Exception e) => Either e a -> m a
eitherToMonadThrow = throwM ||| return
